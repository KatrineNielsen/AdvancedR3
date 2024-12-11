#' Descriptive statistics
#'
#' @param data is a data frame
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

#' Plot the distributions
#'
#' @param data is a data frame
#'
#' @return
plot_distributions <- function(data) {
    ggplot2::ggplot(data, ggplot2::aes(x = value)) +
        ggplot2::geom_histogram() +
        ggplot2::facet_wrap(ggplot2::vars(metabolite), scales = "free")
}
