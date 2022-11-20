# Autifyweb

## Autify Backend Assignment
In fulfillment of Autify's backend engineering take home test. Objective of the task is to create a simple CLI application that fetches web pages and its metadata being stored to disk.

## Methodology
It's a simple Ruby script that is able to capture web pages and its metadata - before being saved to its own dedicated folder in the same root. The metadata is stored in plain text and can be retrieved by passing a flag to the app.

## Assumptione prior to starting
1. All functionalities of the application are kept to only what is stated on the surface level within the test doc
2. Users can etiher store webpages and its metadata, or print out metadata of existing webpages, at any one given time

## Instructions
0. run `bundle` to ensure that all dependencies are available
1. run `ruby capture.rb https://autify.com` to record webpage and metadata to a local directory
2. run `ruby capture.rb -m autify` to print out the saved metadata for an existing directory

run `ruby capture.rb -h` to list out definitions of any flag available for use

## Takeaways
Overall, it's an enjoyable challenge to build CLI applications with a unique problem set. Unfortunately, there isn't enough time to work on the extra credit assignment or to refine the Dockerfile - as I'm quite unfamiliar with Docker at the time of submission.
