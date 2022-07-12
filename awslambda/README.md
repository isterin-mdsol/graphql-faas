1. Run `setup.sh`
2. Get the full URL from the *Outputs:* line.
    base_url = "http://127.0.0.1:4566/..../_user_request_/"
3. Run the graphql-api and set the environmental variable
    ```
    cd ../graphql-api 

    # Replace the URL in the command below with the one you get from step 2
    LAMBDA_URL="http://127.0.0.1:4566/restapis/q2ga9k8myh/test/_user_request_/" pnpm run-dev
    ```


If you make any changes, just rerun `./setup.sh` to let terraform apply the changes