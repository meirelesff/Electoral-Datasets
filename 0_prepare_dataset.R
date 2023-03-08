# ---
# 0 PREPARE DATA FOR USE IN THE R PACKAGE
# ---


# Packages
library(tidyverse)
library(here)


# Load CLEA data
load(here("clea_lc_20220908.RData"))


# Filter cases and select variables
clea <- clea_lc_20220908 %>%
  filter(ctr_n %in% c("Brazil", "Spain", "Denmark")) %>% 
  select(ctr_n, yr, mn, cst_n, cst, pty_n, pty, pvs1, seat) 


# Create cases
brazil <- clea %>%
  filter(ctr_n == "Brazil") %>%
  select(-seat) %>%
  filter(yr > 1988) # Start at democratization

spain <- clea %>%
  filter(ctr_n == "Spain") %>%
  select(-seat)

denmark <- clea %>%
  filter(ctr_n == "Denmark") %>%
  filter(yr >= 1906) %>% # Remove unconsted elections
  filter(yr != 1915) %>% #
  group_by(yr, cst_n, cst) %>%
  mutate(seat_s = seat / sum(seat)) %>%
  ungroup() %>%
  select(-seat) %>%
  mutate(seat_s = ifelse(yr < 2001, NA, seat_s))


# Save
save(brazil, spain, denmark, file = "clea.Rda")

