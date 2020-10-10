#!groovy

/* Checks a folder if changed in the latest commit.
   Returns true if changed, or false if no changes.
*/

def call(String path) {
  try {
    // git diff will return 1 for changes (failure) which is caught in catch, or 0 meaning no changes
    sh "git diff --quiet --exit-code HEAD~1..HEAD ${path}"
    return false
  } catch (err) {
    return true
  }
}
