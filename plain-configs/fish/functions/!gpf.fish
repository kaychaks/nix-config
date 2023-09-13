function !gpf --wraps='git push --no-verify --force-with-lease' --description 'alias !gpf git push --no-verify --force-with-lease'
  git push --no-verify --force-with-lease $argv
        
end
