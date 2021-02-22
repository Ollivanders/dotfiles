#!/bin/sh

README_FILE=../README.md
INDEX_FILE=../index.md
TROUBLESHOOTING_FILE=../troubleshooting.md

# cd ..

function write_to() {
    cat ${2}.md >>${1}
    printf "\n" >>"${1}"
}

function reset_all() {
    printf "" >$README_FILE
    printf "" >$INDEX_FILE
    printf "" >$TROUBLESHOOTING_FILE
}

reset_all

# README
write_to $README_FILE intro
write_to $README_FILE features
write_to $README_FILE setup
write_to $README_FILE todo
write_to $README_FILE acknowledgments

# TROUBLESHOOTING
printf "# Troubleshooting \n" >$TROUBLESHOOTING_FILE
# printf "\`\`\\n" >> $TROUBLESHOOTING_FILE
# $(printf "$(./letsgo.sh -h)") >> $TROUBLESHOOTING_FILE
# printf "\`\`\`\n" >> $TROUBLESHOOTING_FILE

write_to $TROUBLESHOOTING_FILE troubleshooting
write_to $TROUBLESHOOTING_FILE todo

# printf "# Git todo's \n" >>$TROUBLESHOOTING_FILE
# printf "\`\`\`\n" >>$TROUBLESHOOTING_FILE
# $(printf "$(cd .. && git grep -l TODO | xargs -n1 git blame -f -n -w | grep "Your name" | grep TODO | sed "s/.\{9\}//" | sed "s/(.*)[[:space:]]*//")") >>$TROUBLESHOOTING_FILE
# printf "\`\`\`\n" >>$TROUBLESHOOTING_FILE

# Index
write_to $INDEX_FILE intro
write_to $INDEX_FILE features
write_to $INDEX_FILE setup
