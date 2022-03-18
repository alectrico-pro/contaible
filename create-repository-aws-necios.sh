docker rm aws-store
docker build . -t aws-necios
docker run -p 5000:4000 --name aws-store -v $(pwd)/docs:/doc aws-necios bash -c 'jekyll build . && cp * /doc -r && chown 1000:1000 /doc -R'
docker run -p 5000:4000 --volumes-from aws-store -v $(pwd)/docs:/doc aws-necios bash -c 'cd /doc && jekyll serve'
aws ecr create-repository --repository-name aws-necios --region us-west-2
docker tag aws-necios 363696918323.dkr.ecr.us-west-2.amazonaws.com/aws-necios
aws ecr get-login-password | docker login --username AWS --password-stdin 363696918323.dkr.ecr.us-west-2.amazonaws.com/aws-necios 
#Con esto accedo al repositorio, pero solo me devolerá un json
TOKEN=$(aws ecr get-authorization-token --output text --query 'authorizationData[].authorizationToken')
curl -i -H "Authorization: Basic $TOKEN" https://363696918323.dkr.ecr.us-west-2.amazonaws.com/v2/aws-necios/tags/list
