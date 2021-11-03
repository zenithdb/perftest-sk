#!/bin/bash
set -eux

# create graph.png
python graph.py

cat <<EOF > report.md
Info about the run:
\`\`\`
$(cat info.txt)
\`\`\`

Time to run \`pgbench -i\`:
\`\`\`
$(cat pgbench_init.log | tail -n 1)
\`\`\`

Pgbench result:
\`\`\`
$(cat pgbench.log | tail -n 12)
\`\`\`
EOF
cat report.md

GIST=$(gh gist create report.md)
GIST_HASH=${GIST##*/}

rm -rf gist
git clone git@gist.github.com:$GIST_HASH.git gist
mv graph.png gist
cd gist
git add graph.png
git commit -m "Add graph.png"
git push origin master
cd ..


echo "Report: " $GIST
