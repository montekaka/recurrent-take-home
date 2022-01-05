# Recurrent Software Developer Take-Home Assignment

At Recurrent, we work with data we collect from people’s electric vehicles
(EVs). Currently, we collect between one and three data points a day (usually)
from each vehicle. The data we collect includes the following information:

- `charge_reading`: The vehicle’s State of Charge (SoC), a decimal number
  representing the current charge level of the battery in terms of percentage.
  (For example, 0.33 means the battery is 33% charged.)
- `range_estimate`: The estimated range that the vehicle can drive before the
  battery is depleted, expressed in miles as a decimal number.
- `odometer`: The vehicle’s current odometer reading, expressed in miles as an
  integer.
- `plugged_in`: Whether or not the vehicle is plugged in at the time of the
  reading, expressed as a boolean.
- `charging`: Whether or not the vehicle is actively charging at the time of
  the reading, expressed as a boolean.
- `created_at`: Timestamp of the reading, expressed in a string of the format
  "yyyy-mm-dd hh:mm:ss", the timezone is UTC for all readings.
- `vehicle_id`: A unique identifier tied to the vehicle, expressed as a
  string.

The ev_data file in this repo contains a collection of data points over the
course of a few weeks for 5 different vehicles. We provide the file in both
CSV and JSON formats for your convenience since it's sometimes easier to work
with one or the other in a given programming language. You may use whichever
one you prefer, and your program DOES NOT need to work with both file types.

## Task 1: Write some code and a README

Your first task is to write a command line program that reads the data from the
data file and is able to execute these two queries.

1.  `charged_above`: This query should return the number of vehicles that
    reported at least one `charge_reading` above a given % over the whole time
    period. It should take a charge % as an argument. This argument should be a
    decimal, for example 0.33 will be passed to indicate 33%.
2.  `average_daily_miles`: This query should return the average daily miles for
    a given vehicle over the course of the time period of the dataset, so it
    should take `vehicle_id` as an argument. (For example, if the given vehicle
    travelled 140 miles over a two week period, this should return 10).

We would like to be able to execute the query by typing a command that executes
your program by passing in three required arguments.

1.  the path to the data file
2.  the name of the query (specified in bold in the list above)
3.  one argument to be passed to the query (a vehicle identifier, or a number,
    as specified in the query description)

For example: if the program you have written is in ruby, the entry point
file is named "ev_data_query.rb", and you've chosen to work with the CSV
file, then the command you would type to execute query number 2 below is:

```
ruby ev_data_query.rb /path/to/data/file.csv average_daily_miles cat-car
```

## Task 2: Write a ticket for a teammate to implement a new query

Imagine a teammate is planning to expand on your work and implement a new query
in the next sprint. Write a ticket that roughly outlines the work to be done to
implement this new query:

- `drove_nowhere`: This query should return the number of vehicles that were
  not driven at all on a given date, so it should take a date as an argument.

Include this write-up in your README file. We expect to see you call out where
requirements are ambiguous and suggest some potential approaches, but avoid
prescribing exact implementation details.

## What we expect:

- Your program DOES NOT need to work with both CSV and JSON data files. Either
  one is fine and there are no bonus points for making it work on both.
- We don’t expect you to spend more than ~2-4 hours on this. Please don’t
  spend any longer on it, even if you didn’t finish it. That is fine! The next
  stage of the interview process builds on this work.
- You can use any language you prefer, but try to make it easy for us to run
  your code! We happen to be most comfortable with ruby, javascript, python.
- There is no deadline for this, go ahead and send it to us when you are
  ready.
- Submit your solution source code files to us by emailing them to us. You can
  choose one of the following ways:
  - Email a link to a github repo
  - Email a zip file containing the files
  - Email a link to a zip file hosted on a cloud service (dropbox, etc…)
- We prioritize readable code that meets the requirements.
- We expect to see some automated tests for important functionality.
- Most importantly, we expect you to include a README. This should contain:
  - A description of the project with directions about how to run the code.
    (Especially detail this as if someone wouldn’t know how to get started.)
  - Information about assumptions and decisions you made along the way! We’d
    love to hear your thought-process and tradeoffs you made.
  - A discussion of what would you would think about improving if you spent
    more time on it (and why).
  - The ticket write-up from Task 2.


## Submission




### drove_nowhere

This query should return the number of vehicles that were not driven at all on a given date, so it should take a date as an argument.

Todo:

1. Go to the `ev_report.rb` file and add teh `drove_nowhere` method to the `EvReport` class.

2. `drove_nowhere` should take `created_at` as an argument, and returns the number of vehicles.

For example: given the dataset below, and `2020-01-14` as the input, we should expect the funciton return `1`, which is the `cat-car`

| vehicle_id | charge_reading | range_estimate | odometer | plugged_in | charging | created_at |
| --- | --- | --- | --- | --- | --- | --- |
| cat-car | 0.2 | 40  | 1200 | TRUE | TRUE | 2020-01-13 12:01:03 |
| cat-car | 0.73 | 80  | 1200 | TRUE | TRUE | 2020-01-14 22:30:01 |
| clown-car | 1   | 268.35 | 56306 | TRUE | FALSE | 2020-01-04 5:58:52 |
| hamster-car | 0.5 | 123.2 | 26171 | FALSE | FALSE | 2020-01-13 11:52:57 |
| hamster-car | 0.49 | 123.2 | 26173 | FALSE | FALSE | 2020-01-13 13:49:38 |
| hamster-car | 0.49 | 123.34 | 26173 | FALSE | FALSE | 2020-01-14 12:24:08 | 

3. To run the query, you will need to first initial the object wit the csv file path

```
ev_report = EvRport.new('ev_data.csv')
date = Date.parse("2020-01-14")
ev_report.drove_nowhere(date)
```

