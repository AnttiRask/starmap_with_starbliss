# Creating a Star Map for Your Place and Date of Birth

This repo introduces an easy way to create a star map according to, for instance, your place and date of birth. It uses three things:

1) The `plot_starmap()` function from the **starBliss** package to create the star map itself
2) The __ggmap__ package and the Google Maps API to convert the birthplace to get the latitude and longitude
3) A DIY function `decimal_to_dms()` that converts the latitude and longitude from decimal degrees to Degrees Minutes Seconds (DMS) format

And as always, there are numerous functions from the different __tidyverse__ packages that make everything else possible.

## Things to Remember

- If you wish to use the code exactly as it's written, you need to register with the [Google Maps Platform](https://developers.google.com/maps).
At the time of writing this Google offers $300 worth of credits for free (to be used within 90 days). But as with any cloud platform, be mindful
of credit usage!
- When inserting the date of birth, you should use the yyyy-mm-dd (ISO 8601) format.

Have fun!
