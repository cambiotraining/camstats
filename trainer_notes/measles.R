measles <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-02-25/measles.csv')

measles_df <- measles %>%
  filter(mmr > 0) %>%
  transmute(state,
            mmr_threshold = case_when(mmr > 95 ~ "Above",
                                      TRUE ~ "Below")) %>%
  mutate_if(is.character, factor)

measles_df %>% count(state)

library(skimr)
skim(measles_df)

glm_fit <- logistic_reg() %>%
  set_engine("glm") %>%
  fit(mmr_threshold ~ state, data = measles_df)

tidy(glm_fit)
