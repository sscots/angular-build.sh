#!/bin/bash
case "$1" in
  "-build")
    #update backend
    cd backend
    git pull
    if [[ -v $2 ]] && [[ $2 -eq "-install" ]]
        then
                npm install
    fi

    #build docs for backend
    cp ./README.md ./tutorials
    rm -rf ./documentation
    ./node_modules/jsdoc/jsdoc.js -c jsdoc-conf.json api/*

    #update frontend
    cd ../frontend
    git pull
    if [[ -v $2 ]] && [[ $2 -eq "-install" ]]
        then
                npm install
    fi

    #build docs for frontend
    compodoc -p tsconfig.json
    ;;

  "-launch")
    #Build frontend, then remove current prod directory, then replace with newly built one, then restart pm2 process for backend
    cd frontend
    ng build --prod
    rm -rf dist
    mkdir dist
    shopt -s dotglob
    cp -r dist-includes/dist/* dist/
    cp dist-includes/* dist/


    cd ../backend
    npm run db-migrate
    pm2 gracefulReload app.js
    ;;
  *)
    echo "Specify -build or -launch"
    exit 1
    ;;
esac
