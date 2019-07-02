
#!/bin/bash

if [ $# -eq 2 ] ; then
git_revno=$1
filename=$2

elif [ $# -eq 3 ] ; then
git_revno=$1
git_revno2=$2
filename=$3
else
echo "Usage 1: $0 <git revision no.> <filename>"
echo "Usage 2: $0 <git revision no. 1> <git revision no. 2> <filename>"
exit 1
fi

# exporting git repo
mkdir tmp
git export --force -r $git_revno . tmp
if [ $# -eq 3 ]; then
mkdir tmp2
git export --force -r $git_revno2 . tmp2
fi

# generating diff
if [ $# -eq 3 ]; then
latexdiff --flatten tmp/$filename tmp2/$filename > diff.tex
else
latexdiff --flatten tmp/$filename $filename > diff.tex
fi

# compiling output with highlights
pdflatex diff.tex
pdflatex diff.tex

# cleanup
rm -rf tmp
if [ $# -eq 3 ]; then
rm -rf tmp2
fi
rm diff.{aux,log}

#keep diff.tex (to be able to compile with TexShop)
#rm diff.tex

#  diff pdf file
filenameOnly=`echo "$filename" | cut -d'.' -f1`
if [ $# -eq 3 ]; then
mv diff.pdf $filenameOnly-diff-r${git_revno}-r${git_revno2}.pdf
else
mv diff.pdf $filenameOnly-diff-r${git_revno}.pdf
fi
