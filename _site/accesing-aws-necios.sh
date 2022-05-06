aws ecr get-login-password | docker login --username AWS --password-stdin 363696918323.dkr.ecr.us-west-2.amazonaws.com/aws-necios
#Con esto accedo al repositorio, pero solo me devolerá un json
TOKEN=$(aws ecr get-authorization-token --output text --query 'authorizationData[].authorizationToken')
curl -i -H "Authorization: Basic $TOKEN" https://363696918323.dkr.ecr.us-west-2.amazonaws.com/v2/aws-necios/tags/list

