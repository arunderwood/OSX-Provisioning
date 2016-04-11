# OSX-Provisioning

Because it can be messy to have git config files in the DeployStudio Share, it's best to store them outside of the directory.
If you have to recreate the DS Share, you can use these steps.

Clone the repo 
>git clone https://github.com/arunderwood/OSX-Provisioning.git

Copy all the files except .git to the DeployStudio Share
>mv OSX-Provisioning/!(.git) [NEW PATH]

Use git config core.worktree to point the project at the new path
>git config core.worktree "[NEWPATH]"

