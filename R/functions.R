#' descriptive stats
#'
#' @param data
#'
#' @return
descriptive_stats <- function(data) {
    data |>
        dplyr::group_by(metabolite) |>
        dplyr::summarize(dplyr::across(
            value,
            list(
                mean = mean,
                sd = sd
            )
        )) |>
        dplyr::mutate(dplyr::across( # across: Given these columns (.x is a placeholder for the column), do this action
            where(is.numeric),
            ~ round(.x, digits = 1)
        ))
}
