def git_is_dirty
  result = `git status -s`
  puts result.empty? ? "si" : "no"
end

git_is_dirty
# # switch_to_repository
# echo "INPUT_REPOSITORY value: $INPUT_REPOSITORY";
# cd $INPUT_REPOSITORY

# if _git_is_dirty; then
#     BRANCH=$(echo "$GITHUB_REF" | sed "s/refs\/heads\///")

#     # Set up .netrc file with GitHub credentials
#     cat <<- EOF > $HOME/.netrc
#         machine github.com
#         login $GITHUB_ACTOR
#         password $GITHUB_TOKEN
# EOF
#     chmod 600 $HOME/.netrc
#     git config --global user.email "actions@github.com"
#     git config --global user.name "GitHub Actions"

#     git checkout $BRANCH
#     git add "${INPUT_FILE_PATTERN}"
#     git commit -m "$INPUT_COMMIT_MESSAGE" \
#     --author="$GITHUB_ACTOR <$GITHUB_ACTOR@users.noreply.github.com>" ${INPUT_COMMIT_OPTIONS:+"$INPUT_COMMIT_OPTIONS"}
#     git push --set-upstream origin "HEAD:$BRANCH"
# else
#     echo "Working tree clean. Nothing to commit."
# fi
