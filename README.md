# Loftium Take-Home
This repository is a solution to a take-home assigment. Following you can find the **Take-home description** section. Instructions on how it works can be found at the **Solution** section.

## Take-home description

In this take-home, we want you to demonstrate your full skillset as if you are already a teammate here at Loftium. We've provided a set of requirements that resemble a task you might be given in one of our sprints. When you have completed the project, you will make a pull request that will then be code-reviewed by the team.

We wish to respect your time interviewing with us, and as such we hope that this will only take a few hours max. If you find yourself spending more time, please submit your work as-is and include a short write up of where you intended to take it next.

### Overview
Our team is building a web app for booking stays in our portfolio of short-term rentals. We have a database including **listings** and **reservations**, defined as follows:
* A **listing** is a space that is available for a short-term rental (e.g. an Airbnb).
* A **reservation** is an existing booking of that space. Each reservation has a check-in date, when the guest(s) will arrive at the space, and a check-out date, when they will leave.

We have already set up a PostgreSQL database of listing and reservation data (related by `reservations.listing_id` → `listings.id`). You have been tasked with building the REST API that will provide this data to the frontend.

**Read-only Database**  
Host: `take-home-db.cicqgtvbsdsm.us-west-2.rds.amazonaws.com`  
Port: `5432`  
User: `backend`  
Pass: `backend`  
Database: `backend`  

If you prefer, you may use the provided dataset files instead of the database. You may load and parse these however you wish.

### Requirements
Build a REST API service that utilizes the data provided. Your API should include two endpoints.

#### 1. Listings endpoint
This endpoint allows users to filter our listings based on their desired travel dates. It accepts two date params, their requested `check_in_date` and `check_out_date`, and returns all listings that are available within that date window. A listing is _unavailable_ if there is an existing reservation that overlaps the `check_in_date` and `check_out_date`. Otherwise, the listing is available.

For example, let's say listing A has two reservations: one from January 1-4, 2020, and one from January 7-10, 2020. If we call this endpoint with `check_in_date=2020-01-02` and `check_out_date=2020-01-06`, listing A **should not** be included in the result, since it already has a reservation during that time. If we call it with `check_in_date=2020-01-04` and `check_out_date=2020-01-07`, listing A **should** be included in the result, since there are no reservations during that time (note that check-out is in the morning and check-in is in the evening, so two bookings can be adjacent on the same calendar day).

#### 2. Unavailable nights endpoint
This endpoint returns all unavailable (booked) nights for a given listing. For example, for listing A as described above, this endpoint would return the following nights: `2020-01-01`, `2020-01-02`, `2020-01-03`, `2020-01-07`, `2020-01-08`, `2020-01-09`.

### Notes
* You may use whatever stack you are most familiar with, but please use a language that can be easily interpreted by other engineers.
* Likewise, you may structure your endpoints and format their output in whatever way makes the most sense to you.
* Feel free to reach out if you have any questions about these requirements.

### Submission
* Create a new branch in this repo for you to work in.
* Submit your work as a pull request to the `master` branch.
* Please include instructions on how to run your service.

## Solution

The solution is implemented as a Rails 6 API application.

### Instructions:
- Download this branch
- In  the command line, go to the downloaded folder
- Check you have Ruby 2.7 and run `bundle install`

### Run the application:
- The application is configured to access the provided PostgreSQL database
- In the console run `rails s`
- Now you can request the endpoints at `localhost:3000/api/v1/listings/from/:check_in_date/to/:check_out_date` and `localhost:3000/api/v1/listings/:id/unavailable_nights`. Provide the correspondant parameters `check_in_date`, `check_out_date` and `:id`.

### Documentation:
- While the server is running, you can access the API documentation at `http://localhost:3000/docs`

### Tests:
- Tests lives under `specs` folder
- Be sure you have docker-compose installed
- In the command line, from the base directory start docker compose with `docker-compose create` and then `docker-compose start`
- Run `bundle exec rspec` to run all tests.
- Running all tests you can obtain a report on test coverage. This report is powered by `simplecov` gem and lives at `coverage/index.html`.
- In console you can run `brakeman` and get a static analysis security report.
- In console you can run `bundle-audit`. It checks that the used gems has no vulnerabilities.
- You can stop docker-compose runing `docker-compose stop`.
