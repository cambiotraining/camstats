library(tidyverse)
library(tidymodels)

data("penguins")
head(penguins)

ggplot(penguins, aes(bill_depth_mm, bill_length_mm, colour = species)) +
  geom_point()

set.seed(123)

pg_split <- initial_split(penguins)

# Create data frames for the two sets:
pg_train <- training(data_split)
pg_test  <- testing(data_split)


pg_rec <-
recipe(bill_length_mm ~ bill_depth_mm, data = pg_train)

summary(pg_rec)

pg_mod <-
  linear_reg() %>%
  set_engine("glm")

pg_wflow <-
  workflow() %>%
  add_model(pg_mod) %>%
  add_recipe(pg_rec)

pg_wflow

pg_fit <-
  pg_wflow %>%
  fit(data = pg_train)

pg_fit %>%
  extract_fit_parsnip() %>%
  tidy()

# oh dear, same as:
lm(bill_length_mm ~ bill_depth_mm, data = pg_train)




pg_augmented <-
  augment(pg_fit, pg_test)

folds <-
  vfold_cv(pg_train, v = 10)

pg_fit_rs <-
  fit_resamples(pg_wflow, folds)

pg_fit_rs

collect_metrics(pg_fit_rs)

show_best(pg_fit_rs, metric = "rmse")

# predict values of bill_length_mm in the test data set
predict(pg_fit, pg_test)
# even better, augment them with the existing data
augment(pg_fit, pg_test)


pg_fit_pred <-
  augment(pg_fit, pg_test) %>%
  select(bill_length_mm, .pred)

# performance metrics of the test set
pg_fit_pred %>%
  rmse(truth = bill_length_mm, .pred )

# airpoll ----
# analysis based on https://www.thomasvanhoey.com/post/2021-10-12-tidymodels-interactions/
airpoll <- read_csv("../corestats-in-r/data/tidy/CS5-H2S.csv") %>% select(-id)
air_split <- initial_split(airpoll)
air_train <- training(air_split)
air_test <- testing(air_split)

air_rec <- recipe(hydrogen_sulfide ~ .,
                  data = air_train)

air_rec_int <- air_rec %>%
  step_dummy(all_nominal_predictors()) %>%
  step_interact(terms = ~ daily_temp:starts_with("treatment_plant"))

prep_air_rec_int <- prep(air_rec_int, training = air_train)
bake(prep_air_rec_int, new_data = NULL)

air_mod <- linear_reg() %>% set_engine("lm") %>% set_mode("regression")
air_wflow <- workflow() %>% add_model(air_mod) %>% add_recipe(air_rec)
# interaction workflow
air_int_wflow <- air_wflow %>% update_recipe(air_rec_int)

air_fit <- air_wflow %>% last_fit(split = air_split)
air_fit %>% extract_fit_parsnip() %>% tidy()

air_fit_int <- air_int_wflow %>% last_fit(split = air_split)
air_fit_int %>% extract_fit_parsnip() %>% tidy()

air_norm_mod <- air_fit %>% extract_fit_engine()
air_int_mod <- air_fit_int %>% extract_fit_engine()

anova(air_norm_mod, air_int_mod)

air_fit_int %>% collect_metrics()

air_int_mod %>% glance()
air_int_mod %>% tidy()

air_fit_int %>%
  collect_predictions() %>%
  ggplot(aes(.pred, hydrogen_sulfide)) +
  geom_point() +
  geom_abline(intercept = 0, slope = 1, color = "orange") +
  labs(x = "Predicted hydrogen sulfide levels",
       y = "Observed hydrogen sulfide levels",
       title = "R² plot") +
  theme_minimal()

# glm proportional response test ----
challenger <- read_csv("data/MS1-Challenger.csv")

ch_mod <- linear_reg(mode = "regression") %>%
  set_engine("glm", family = "binomial")

challenger <-
challenger %>%
  mutate(intact = 6 - damage,
         prop_damaged = damage / 6,
         sum_rings = damage + intact)

original <- challenger

challenger <- challenger %>% filter(damage < 5)

ch_rec <- recipe(prop_damaged ~ temp, data = challenger, weights = sum_rings)
ch_wflow <- workflow() %>%
  add_model(ch_mod) %>%
  add_recipe(ch_rec)

ch_fit <- ch_wflow %>%
  fit(data = challenger)

ch_fit %>% tidy()
ch_fit %>% glance()

disaster <- original %>% filter(damage == 5)
ch_fit %>% augment(new_data = disaster)
