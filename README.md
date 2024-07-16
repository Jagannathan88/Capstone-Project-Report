### Capstone Project repo: https://github.com/Jagannathan88/capstone-project.git
## Dockerfile: 
    • It pulls nginx latest docker image
    • Copy capstone-project app content to the web service directory in the nginx image 
    • Builds a custom nginx image of capstone web app
    • exposing port 80

## build.sh:
    • Read and stores the user data in a variable IMAGE_NAME
    • Read and stores the user data in a variable TAG
    • Executes the build command docker build -t "$IMAGE_NAME:$TAG" .
    • Used if_else condition to display the success and failure message of build process

## Testing video clips added in below mentioned files:
    • dev_ environment_auto_build_trigger.webm --> Video explanation for dev environment auto build trigger 
    • prod_ environment_auto_build_trigger.webm --> Video explanation for prod environment auto build trigger
    • tested_dev_prod_at_a_time.webm --> Made a video clip for dev and prod environment both testing at a time

## Added and explied all the screenshots related to this project here:
    • https://docs.google.com/document/d/e/2PACX-1vQ5zwMK63GUE6nBmOB1Fo3Q7C9MFsFWw05VcgsnJmC7Y1dF3ca0417gaxq-5Hj9PYbMcE2_rrfJiE3h/pub

