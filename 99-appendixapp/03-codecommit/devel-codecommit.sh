# AWS CodeCommit
# Add repositories
git remote -v
git remote show origin

# Add/Remove remote entry in ~/.git/config file
git remote set-url --add --push origin \
  https://git-codecommit.us-west-2.amazonaws.com/v1/repos/tutorialdotnet

git remote set-url --add --push origin \
  ssh://APKAYMHYEW7WOI45TSO3@git-codecommit.us-west-2.amazonaws.com/v1/repos/tutorialdotnet

git push --force

# Generate public key from private key
cd ~/.ssh && ssh-keygen -t rsa -b 4096

cat ~/.ssh/codecommit_rsa.pub

# Create a config file in the ~/.ssh directory, and then add the following lines
chmod 600 config

Host git-codecommit.*.amazonaws.com
  User APKAYMHYEW7WOI45TSO3
  IdentityFile ~/.ssh/codecommit_rsa

ssh -v git-codecommit.us-west-2.amazonaws.com

git clone \
  ssh://APKAYMHYEW7WOI45TSO3@git-codecommit.us-west-2.amazonaws.com/v1/repos/tutorialdotnet tutorialdotnet
