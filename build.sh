#git rm -r o/
perl oikumena.pl &>.build
git add .
git commit -m "$(date)"
#git push origin gh-pages
git push origin master
