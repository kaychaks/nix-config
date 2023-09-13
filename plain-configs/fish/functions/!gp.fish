function !gp --wraps='git push --no-verify' --description 'alias !gp git push --no-verify'
  git push --no-verify $argv
        
end
