
# development repo (current)

source="$(pwd)"

# the live repository you push to

build="$1"

# ============= RUN ===================

cd "$build"

perl "$source/oikumena.pl" >build.json
cp -Rf "$source/oikumena/public" "$build/."

#mv -f build.json $live/.
#mv -f index.html $live/.
#mv -f o/ $live/.

# =========== PUSH LIVE ===============

#git add .
#git commit -m "$(date)"
##git push origin gh-pages
#git push origin master

# =====================================

echo "OK"
