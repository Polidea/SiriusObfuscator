# Build Notes Guide

Use this guide to build the Sirius umbrella command line project.

1. Clone the source  
   `git clone ssh://git@gitlab2.polidea.com:23/SwiftObfuscator/ObfuscatorTool.git`

2. Add git-subtrees remotes
   `bash Scripts/git_remotes.sh`

3. (optional, do it if there's a need for updating the dependencies) Update dependecies
   `bash Scripts/git_update.sh`

4. Build all the dependent projects and the main project
   `bash Scripts/build.sh`