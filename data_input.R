# Data input


values <- tibble::tribble(
   ~Experimental,   ~Lower,  ~Upper,
              NA,       NA,      NA,
           5.0,      5,     5,
          150,   150,  150,
            6,     6,    6,
             1,      4,     4,
              NA,       NA,      NA,
         15000,       NA,      NA,
         10350,       NA,      NA,
          0.69,       NA,      NA,
            6,     6,    6,
  
         1.12,  1.00, 2.00,
         1.81,  1.00, 5.00,
          0.8,  0.70, 1.00,
          0.59,   0.40,  0.60,
          0.02,   1.0,  3.0,
  
         -0.03,  -0.40,  0.10,
         -0.76,  -1.00,  0.10,
          0.06,   0.04,  0.07,
          0.26,   0.01,  0.45,
         0.014,  0.001, 0.020,
         0.075,  0.010, 0.080,
         0.005, -0.010, 0.010,
         0.013,  0.001, 0.030,
         0.305,  0.030, 0.390,
         0.389,  0.005, 1.000,
  
        0.0189,  0.005, 0.020,
           40,     0,   90,
  
          1,       NA,      NA,# 1 = FIAT, 0 = Market
          5.8,  2.50, 6.00,
         0.45,       NA,      NA,
         0.03,  0.01, 0.03,
          150,   150,  150
  )


inputs <- c("Inputs, Adaptive (Debt Forecast-informed) Policy",
  "Policy Adaptation Foresight Horizon (# years ahead forecast to which policy adapts)",
  "Debt/GDP threshold level for Adaptive Policy to be initiated",
  "Maximum  Reduction of Total Expenditures / Year",
  "Fiscal Policy Orientation (1-6)",
  "Economy: Basic Parameters",
  "GDP, initial",
  "Debt, initial",
  "Debt/GDP, initial (calculated)",
  "Discount Rate:",
  
  "Productivity Growth (trend)",
  "Capital Stock Growth (trend)",
  "Population Growth (trend)",
  "Population Growth sensitivity to Slow Economic Growth",
  "Health Care Cost Growth in Excess of Broad Inflation (pct pt)",
  
  "Labor Growth sensitivity to Personal Taxes",
  "Capital Stock Growth sensitivity to Corporate Taxes",
  "Labor Growth sensitivity to Infrastructure",
  "Capital Stock Growth sensitivity to Infrastrcture",
  "Growth senstivity to Spending on Social Protection",
  "Growth senstivity to Spending on Health",
  "Growth senstivity to Spending on Defense",
  "Growth senstivity to Spending on Education",
  "Growth senstivity to Spending on Infrastructure",
  "Growth senstivity to Spending on R+D",
 
  "dGDP / d(Debt/GDP)",
  "Threshold Debt/GDP for Debt-Sensitive Growth",
  
  "Interest Rate set by FIAT or MARKET?",
  "Interest Rate, Trend",
  "dInterestRate / dGDP",
  "dInterestRate / d(Debt/GDP)",
  "Threshold Debt/GDP for Loss of Fiat")

values$inputs <- inputs

# Time series taken from Excel model
# pop0 <- 140L
# population <- c(142L, 143L, 144L, 146L, 145L, 146L, 147L, 147L, 148L, 148L, 155L, 156L, 157L, 158L, 157L, 158L, 157L, 158L, 157L, 157L, 157L, 157L, 158L, 158L, 159L, 159L, 160L, 161L, 161L, 161L, 162L, 162L, 162L, 162L, 162L, 162L, 161L, 161L, 160L, 159L, 158L, 156L, 155L, 152L, 150L, 147L, 143L, 140L, 137L, 134L, 132L, 129L, 126L, 123L, 121L, 118L, 116L, 113L, 111L, 108L, 106L, 104L, 102L, 99L, 97L, 95L, 93L, 91L, 89L, 87L, 85L, 84L, 82L, 80L, 78L)

kTax <- c(0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00)


kInf <- c(0.00, 0.00, 0.00, 0.00, -4.11, -4.99, -6.57, -8.39, -10.68, -13.27, 0.94, 0.00, 0.00, 0.00, -7.09, -8.23, -10.81, -13.40, -16.13, -18.00, -18.97, -19.29, -19.41, -19.44, -19.46, -19.47, -19.48, -19.49, -19.50, -19.51, -19.52, -19.54, -19.55, -19.57, -19.58, -19.60, -19.62, -19.64, -19.66, -19.67, -19.68, -19.69, -19.68, -19.67, -19.64, -19.75, -19.88, -20.03, -20.17, -20.32, -20.47, -20.62, -20.78, -20.93, -21.08, -21.24, -21.38, -21.53, -21.67, -21.81, -21.95, -22.08, -22.20, -22.32, -22.44, -22.56, -22.66, -22.77, -22.87, -22.97, -23.06, -23.14, -23.23, -23.31, -23.39)/100

economyDashboard <- tibble::tribble(
                                                                    ~Input, ~Value,
                                                             "GDP initial",  15000,# B15
                                                            "dGDP initial",   0.03,# B17
                                                     "dGDP / d/(Debt/GDP)", 0.0189,# B19
                      "Threshold Debt/GDP for onset of dGDP / d(Debt/GDP)",    0.4,# B20
                                                        "Debt/GDP initial",   0.69,# B21
                                                            "Debt initial",  10350,# B23
                                                       "Shock 1 dGDP year",     10,# B25
                                                  "Shock 1 dGDP magnitude",  0.122,# B26
                                                       "Shock 2 dGDP year",     12,# B27
                                                  "Shock 2 dGDP magnitude", 0.0338,# B28
                             "Shock recovery period (years, linear decay)",      3# B29
                      )


budgetLines <- tibble::tribble(
                                  ~type, ~pol, ~trend, ~adap,
                      "Personal Income", -0.1,  0.065,    0L,
                                 "FICA",    0,  0.058,    0L,
                            "Corporate", -0.1,  0.013,    0L,
                                "Other",    0,  0.012,    0L,
                              "Soc Sec", -0.1,  0.048,    0L,
                               "Health", -0.1,  0.056,    0L,
                      "Other Mandatory",    0,  0.034,    0L,
                              "Defense", -0.1,  0.048,    0L,
                                  "R+D", -0.1,  0.008,    0L,
           "Education (as d % Exp/GDP)", -0.1,  0.017,    0L,
                       "Infrastructure", -0.1,  0.017,    0L
           )


# Budget Line % by Horacio
tibble::tribble(
                  ~Budget.Line, ~`initial.%GDP`, ~Policy.Change, ~`%GDP`, ~GDP,    ~Rev.or.Exp,
             "Policy: Revenue",              NA,             NA,  0.1344,  "$", "$ GDP * %GDP",
          "TaxPersonal Income",           0.065,           -0.1,  0.0585,  "$", "$ GDP * %GDP",
            "TaxPersonal FICA",           0.058,             NA,  0.0522,  "$", "$ GDP * %GDP",
                "TaxCorporate",           0.013,           -0.1,  0.0117,  "$", "$ GDP * %GDP",
                       "Other",               0,              0,   0.012,  "$", "$ GDP * %GDP",
         "Policy: Expenditure",              NA,             NA,  0.2077,  "$", "$ GDP * %GDP",
                  "ExpSoc Sec",           0.048,           -0.1,  0.0432,  "$", "$ GDP * %GDP",
                   "ExpHealth",           0.056,           -0.1,  0.0504,  "$", "$ GDP * %GDP",
          "Exp OtherMandatory",               0,              0,  0.0335,  "$", "$ GDP * %GDP",
                  "ExpDefense",          0.0475,           -0.1,  0.0428,  "$", "$ GDP * %GDP",
  "Discretionary, non-Defense",           0.042,              0,  0.0378,  "$", "$ GDP * %GDP",
                      "ExpR+D",          0.0084,           -0.1,  0.0076,  "$", "$ GDP * %GDP",
                "ExpEducation",          0.0168,           -0.1,  0.0151,  "$", "$ GDP * %GDP",
           "ExpInfrastructure",          0.0168,           -0.1,  0.0151,  "$", "$ GDP * %GDP"
  )


RDMdash <- tibble::tribble(
                                                                     ~INPUTS, ~Experimental.Value, ~Lower.Bound, ~Upper.Bound,
                                           "PRODUCTIVITY Growth Rate, trend",              0.0112,         0.01,         0.02,
                                          "CAPITAL Stock Growth Rate, trend",              0.0181,         0.01,         0.05,
                                             "POPULATION Growth Rate, trend",             0.00837,        0.007,         0.01,
                                   "INTEREST RATE on Government Debt, trend",             0.05763,        0.025,         0.06,
                                "HEALTH CARE Cost Excess Growth Rate, trend",               0.022,         0.01,         0.03,
                               "Interest Rate SENSITIVITY to Debt/GDP Ratio",            0.000264,        1e-04,        3e-04,
                                 "Growth Rate SENSITIVITY to Debt/GDP Ratio",              0.0189,        0.005,         0.02,
                   "Interest Rate sensititivity to Debt, Debt/GDP THRESHOLD",                 1.5,          1.5,          1.5,
                       "Growth Rate sensitivity to Debt, Debt/GDP THRESHOLD",                 0.4,            0,          0.9,
                         "Population Growth Rate SENSITIVITY to Growth Rate",               0.588,          0.4,          0.6,
             "Potential Output sensitivity to SOCIAL PROTECTION expenditure",             0.01428,        0.001,         0.02,
                        "Potential Output sensititivy to HEALTH expenditure",              0.0749,         0.01,         0.08,
                       "Potential Output sensititivy to DEFENSE expenditure",              0.0049,        -0.01,         0.01,
                           "Potential Output sensititivy to R&D expenditure",             0.38899,        0.005,            1,
                     "Potential Output sensititivy to EDUCATION expenditure",             0.01307,        0.001,         0.03,
                "Potential Output sensititivy to INFRASTRUCTURE expenditure",              0.3051,         0.03,         0.39,
                    "Labor Supply sensitivity to INFRASTRUCTURE expenditure",              0.0626,         0.04,         0.07,
                   "Capital Stock sensitivity to INFRASTRUCTURE expenditure",              0.2614,         0.01,         0.45,
                             "Labor Supply sensitivity to PERSONAL tax rate",              -0.025,         -0.4,          0.1,
                           "Capital Stock sensitivity to CORPORATE tax rate",               -0.76,           -1,          0.1,
                              "Adaptive Policy FORESIGHT time-frame (years)",                   5,            5,            5,
                         "Adaptive Policy THRESHOLD FORECAST Debt/GDP ratio",                 1.5,          1.5,          1.5,
                                      "Maximum Expenditure Reduction / Year",                0.06,         0.06,         0.06,
                                                                      "Plan",                   4,            4,            4,
                                      "Interest Rate set by FIAT or MARKET?",                   1,            1,            1,
                                                              "Shock 1 year",                  10,           10,           10,
                                                              "Shock 1 dGDP",               0.122,          0.1,         0.15,
                                                              "Shock 2 year",                  12,           12,           12,
                                                              "Shock 2 dGDP",              0.0338,         0.02,         0.05,
                                      "Shock recovery (years, linear decay)",                   3,            3,            3,
                                                             "Discount Rate",                0.06,         0.06,         0.06
             )


  
policies <- tibble::tribble(
                        ~`PLAN.NAME:`, ~Baseline, ~Balanced.Response, ~Expenditure.Balancing.Response, ~Government.Reduction.Orientation, ~Revenue.Balancing.Response, ~Public.Investment.Orientation,
                           
                     "d Tax Personal",        0L,                 0L,                              0L,                              -0.1,                          0L,                              0,
                         "d Tax FICA",        0L,                 0L,                              0L,                                 0,                          0L,                              0,
                    "d Tax Corporate",        0L,                 0L,                              0L,                              -0.1,                          0L,                              0,
                            "d Other",        0L,                 0L,                              0L,                                 0,                          0L,                              0,
              "d Exp Social Security",        0L,                 0L,                              0L,                              -0.1,                          0L,                              0,
                       "d Exp Health",        0L,                 0L,                              0L,                              -0.1,                          0L,                              0,
              "d Exp Other Mandatory",        0L,                 0L,                              0L,                                 0,                          0L,                              0,
                      "d Exp Defense",        0L,                 0L,                              0L,                              -0.1,                          0L,                              0,
                          "d Exp R&D",        0L,                 0L,                              0L,                              -0.1,                          0L,                            0.1,
                    "d Exp Education",        0L,                 0L,                              0L,                              -0.1,                          0L,                            0.1,
               "d Exp Infrastructure",        0L,                 0L,                              0L,                              -0.1,                          0L,                            0.1
              )

adaptives <- tibble::tribble(
                            ~Adaptive.Policy, ~Baseline, ~Balanced.Response, ~Expenditure.Balancing.Response, ~Government.Reduction.Orientation, ~Revenue.Balancing.Response, ~Public.Investment.Orientation,
               "% Response as d Expenditure",        0L,                0.5,                              1L,                                1L,                         0.3,                            0.3,
                   "% Response as d Revenue",        0L,                0.5,                              0L,                                0L,                         0.7,                            0.7,
                      "max % d Tax Personal",        0L,                  1,                              0L,                                0L,                           1,                              1,
                     "max % d Tax Corporate",        0L,                  1,                              0L,                                0L,                           1,                              1,
               "max % d Exp Social Security",        0L,                  1,                              1L,                                1L,                           1,                              1,
                        "max % d Exp Health",        0L,                  1,                              1L,                                1L,                           1,                              1,
                       "max % d Exp Defense",        0L,                  1,                              1L,                                1L,                           1,                              1,
                           "max % d Exp R&D",        0L,                  1,                              1L,                                1L,                         0.2,                            0.2,
                     "max % d Exp Education",        0L,                  1,                              1L,                                1L,                         0.2,                            0.2,
                      "d Exp Infrastructure",        0L,                  1,                              1L,                                1L,                         0.2,                            0.2
               )

  