#docker build . --tag cont
docker run cont 
git add .
git commit --all -m "automatico"
git push

cd doc
#esto usa una imagen que genera web estaticos con jekyll
docker run -it --rm -v "$PWD":/usr/src/app -p "4000:4000" starefossen/github-pages
git add .
git commit --all -m "Automatico"
git push
