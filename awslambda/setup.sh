#!/bin/bash

# Let's do some checks
if (! docker stats --no-stream &> /dev/null ); then
  echo "You must have docker installed and kubernetes turned on"
  exit 1
fi
if (! command -v brew &> /dev/null ); then
  echo "You must have homebrew installed"
  exit 1
fi
if (! command -v terraform &> /dev/null ); then
  echo "You must install terraform"
  exit 1
fi
if (! command -v pip &> /dev/null ); then
  echo "You must install python 3 and pip"
  exit 1
fi

# Install a virtual environment and python requirements
pip install -r requirements.txt

# Start localstack server in the background
localstack start -d

for resolver in ./resolvers/{clients,studies,subjects,sites,visits,forms}.js; do
    dir=`dirname $resolver`
    file=`basename $resolver`
    extension="${file##*.}"
    filename="${file%.*}"
    rm ${dir}/${filename}.zip
    zip -r9 -j ${dir}/${filename}.zip ${dir}/${file} ${dir}/database.json
    echo ${dir}/${filename}.zip
done

terraform init
terraform plan
terraform apply --auto-approve