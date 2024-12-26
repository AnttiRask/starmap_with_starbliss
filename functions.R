#' Converts decimal degrees to Degrees Minutes Seconds (DMS) format.
#'
#' @param decimal A numeric vector of decimal degrees
#' @param is_latitude A logical value indicating whether the decimal represents latitude (TRUE) or longitude (FALSE). Defaults to TRUE
#' @return A character vector of DMS formatted strings
#'
#' @examples
#' decimal_to_dms(34.0522)
#' decimal_to_dms(-118.2437, is_latitude = FALSE)
decimal_to_dms <- function(decimal, is_latitude = TRUE) {
    
    tibble(decimal = decimal, is_latitude = is_latitude) %>%
        mutate(
            # Determine the direction (N, S, E, W) based on the sign and whether it's latitude or longitude
            direction = case_when(
                is_latitude  & decimal >= 0 ~ "N",
                is_latitude  & decimal  < 0 ~ "S",
                !is_latitude & decimal >= 0 ~ "E",
                !is_latitude & decimal  < 0 ~ "W",
                TRUE ~ NA_character_ # Handle NA input
            ),
            # Calculate absolute decimal for degree, minute and second calculation
            abs_decimal = abs(decimal),
            # Extract the integer part as degrees
            degrees = floor(abs_decimal),
            # Calculate minutes
            minutes = floor((abs_decimal - degrees) * 60),
            # Calculate seconds, rounded to the nearest integer
            seconds = round(((abs_decimal - degrees) * 60 - minutes) * 60, 0),
            # Create the DMS string using str_glue for easy formatting
            dms = str_glue("{degrees}°{minutes}'{seconds}\"{direction}")
        ) %>%
        # Extract the DMS strings as a vector
        pull(dms)
}

#' Generates and optionally saves a starmap based on location and birth date.
#'
#' @param post_office Character string of the post office
#' @param zip_code Character string of the zip code
#' @param country Character string of the country
#' @param birth_date Date object or character string in "yyyy-mm-dd" format
#' @param save Logical value indicating whether to save the plot as a PNG file. Defaults to TRUE.
#' @return If save is FALSE, returns the ggplot object. Otherwise, saves the plot and returns NULL.
#'
#' @examples
#' # Needs a valid google api key
#' # draw_starmap("Los Angeles", "90001", "USA", "1990-01-01")
draw_starmap <- function(post_office, zip_code, country, birth_date, save = TRUE) {
    
    # Create the full location string
    location <- str_glue("{post_office}, {zip_code}, {country}")
    
    # Register Google Maps API key. Replace with your actual key.
    register_google(key = key)
    
    # Geocode the location to get latitude and longitude
    location_results <- geocode(
        location = location,
        output   = "all"
    )
    
    # Extract latitude and convert to DMS format
    latitude  <- location_results %>% 
        pluck("results", 1, "geometry", "location", "lat") %>% 
        decimal_to_dms()
    
    # Extract longitude and convert to DMS format
    longitude <- location_results %>% 
        pluck("results", 1, "geometry", "location", "lng") %>% 
        decimal_to_dms(is_latitude = FALSE)
    
    # Generate the starmap
    p <- plot_starmap(
        location    = str_glue("{post_office}, {zip_code}, {country}"),
        date        = birth_date,
        style       = "black",
        line1_text  = str_glue("{post_office}, {country}"),
        line2_text  = format(ymd(birth_date), "%B %d, %Y"),
        line3_text  = str_glue("{latitude}, {longitude}")
    )
    
    # Save the plot if save is TRUE
    if (save == TRUE) {
        
        ggsave(
            str_glue("{post_office}_{country}_{birth_date}.png"),
            plot   = p,
            path   = "output/",
            width  = unit(10, 'in'),
            height = unit(15, 'in')
        )
        
    } else {
        # Return the plot object if save is FALSE.
        p
    }
}