#UI FOR CLIMATE ACTION SHINY DASHBOARD============================================================================
#THEME -----------------------------------------------------------------------------------------------------------
TOTA_theme <- create_theme( #Set colours
  adminlte_color(
    light_blue = "#004B55",
    yellow = "#BCB49E",
    orange = "#F6BC1A",
    teal = "#76ACA9",
    fuchsia = "#D11B4A"
  )
)

#FOOTER ---------------------------------------------------------------------------------------------------------
footer_TOTA <- tags$footer( 
  tags$style(HTML("
    @media (max-width: 600px) {
      #footer-logo img {
        min-width: 60px;
      }
      #footer-text p {
        font-size: 12px !important;
      }
      #footer-credit p {
        font-size: 11px !important;
      }
    }
  ")),
  div(
    div(
      tags$img(
        src = "side_bar_logo.png",
        width = "80%",
        style = "display: block; margin: 0 auto;"
      ),
      id = "footer-logo",
      style = "width: 15%; display: flex; align-items: center; justify-content: center;"
    ),
    
    div(
      p("Thompson Okanagan Tourism Association",
        style = "font-weight: bold; margin-bottom: 5px;"
      ),
      
      tags$a(
        "www.totabc.org",
        href = "https://www.totabc.org/",
        target = "_blank",
        style ="color: white;"
      ),
      
      p("2280-D Leckie Road, Kelowna,",
        style = "margin-bottom: 2px;"
      ),
      
      p("British Columbia, V1X 6G6",
        style = "margin-bottom: 0;"
      ),
      
      id = "footer-text",
      style = "width: 60%; color: white; display: flex; flex-direction: column; justify-content: center; padding-left: 5%;"
    ),
    
    div(
      tags$p(
        tags$a(
          "Created by Alexis Samp",
          href = "https://ca.linkedin.com/in/alexis-samp-b89678342",
          target = "_blank",
          style ="color: white;"
        ),
        style = "color: white; width: 100%; font-size: 14px; text-align: center; text-decoration: underline;"
      ),
      id = "footer-credit"
    ),
    style = "width: 100%; background-color: #004B55; display: flex; align-items: center; padding: 20px 5%; box-sizing: border-box; color: white;"
  ),
  style = "position: relative; bottom: 0; left: 0; width: 100%; z-index: 9999;"
)

#HEADER -----------------------------------------------------------------------------------------------------------
ui <- dashboardPage(
  dashboardHeader(
    title = "Local Satisfaction",
    tags$li(
      class = "dropdown",
      tags$a(
        href = "https://tota-insto-hub.share.connect.posit.cloud/",
        icon("globe"),
        " TOTA INSTO HUB",
        style = "
        color: white;
        font-size: 18px;
        padding: 15px;
        text-decoration: underline;",
      )
    )             
  ),
#SIDE BAR / NAV --------------------------------------------------------------------------------------------------
  dashboardSidebar(
    sidebarMenu(
      id = "tabs",
      menuItem("Overview", tabName = "overview", icon = icon("readme")),
      menuItem("Tourism Industry", tabName= "statements", icon = icon("people-group")),
      menuItem("Tourism & Community", tabName = "preceptions", icon = icon("user-pen")),
      menuItem("Back to Hub", tabName = NULL, icon = icon("globe"), href = "https://tota-insto-hub.share.connect.posit.cloud/", newtab = FALSE)
    ),
    
    tags$img(
      src = "side_bar_logo.png",
      width = "85%",
      style = "display: block; margin: 0 auto; padding-top: 40px;"
    ),
    
    tags$img(
      src = "UN_side_bar_logo.png",
      width = "85%",
      style = "display: block; margin: 0 auto; padding-top: 40px;"
    )
  ),

#OVERVIEW TAB-----------------------------------------------------------------------------------------------------
  dashboardBody(
    use_theme(TOTA_theme),
    
    tabItems(
      
      tabItem(
        tabName = "overview",
        
        tags$img(
          src = "banner.png",
          width = "100%",
          style = "position: relative;"
        ),
        p("Destination BC/Kari Medig"),
        
        fluidRow(
          width = "100%",
          
          column(
            width = 12,
            h2("About this Dashboard"),
            p("The purpose of this dashboard is to support TOTA's local satisfaction reporting for the ",
              tags$a(
                href = "https://www.untourism.int/observatories/thompson-okanagan",
                "UN Tourism International Network of Sustainable Tourism Observatories (INSTO)",
                target = "_blank",
                style = "color: #76ACA9; text-decoration: underline;"
              ),
              " and contribute to ongoing efforts to better understand the relationship between
               local residents and tourism in the Thompson Okanagan Region."),
            br(),
            style = "font-size: 18px;"
          ),
          
          column(
            tags$head(tags$style(
              HTML(
                ".explore-link {
                    display: block;
                    font-size: 18px;
                    font-weight: 600;
                    margin-top: 10px;
                    margin-bottom: 10px;
                    color: #004B55;
                    text-decoration: none;
               }
               .explore-link:hover {
                  text-decoration: underline;
                  cursor: pointer;
               }"
              )
            )),
            
            width = 6,
            h2("What is Local Satisfaction?"),
            
            p("Local satisfaction measures how residents perceive tourism and its impact on their community. Monitoring local satisfaction helps 
              destinations understand whether tourism growth is being balanced with residents’ quality of life and well-being.
              This information supports informed destination management, helping ensure tourism remains beneficial, sustainable, and supported by the communities that experience it."),
            br(),
            
            h2("What Can Be Explored?"),
            
            actionLink(
              "statements_link",
              strong("Tourism Industry - Do residents agree that tourism has a positive impact on the community?"),
              class = "explore-link"
            ),
            p("Compare residents perceptions of tourism across regions."),

            actionLink(
              "preceptions_link",
              strong("Tourism & Community - How do residents perceive the amount of tourism in their community?"),
              class = "explore-link"
            ),
            p("Compare perceptions over seasons and years."),
            br()
          ),
          
          column(
            width = 6,
            tags$img(
              src = "region_map_bg.png",
              width = "70%",
              style = "display: block; margin: 0 auto;"
            ),
            p("The scope of the dashboard is the Thompson Okanagan Tourism Region,", br(), "British Columbia, Canada", style = "text-align: center; font-size: 14px;"),
          ),
          
          tags$style(
            HTML(
              ".explore-link {
                  color: #42817A;
                  font-size: 20px;
                  font-weight: bold;
                  text-decoration: none;
              }
              .explore-link:hover {
                  text-decoration: underline;
              }"
            )
          ),
          style = "width: 100%; padding: 20px; font-size: 18px;"
        )
      ), 
      
  #TOURISM INDUSTRY TAB -------------------------------------------------------------------------------------------------------------------
      tabItem(
        tabName = "statements",
        
        tags$style(HTML("
          @media (max-width: 600px) {
            #StatementsBarPlot {height: 350px !important; }
            #OverTimePlot {height: 350px !important; }
          }"
        )),
        
        fluidRow(
          box(
            title = "Tourism Industry - Do residents agree that tourism has a positive impact on the community?",
            solidHeader = TRUE,
            width = 12,
            p("This data measures residents’ agreement on these 3 statements:"),
            HTML("<ul><li>Overall, I believe the positive impacts of tourism in my community outweigh the negative impacts</li>
                 <li>Overall, tourism contributes positively to the quality of life of my community</li>
                 <li>Tourism supports a greater diversity of amenities than would otherwise exist in my community</li></ul>"),
            p("Tracking these perceptions over time and comparing them with other regions can identify areas of strength, emerging concerns, 
              and opportunities to ensure tourism continues to benefit both visitors and residents."),
            style = "font-size: 18px;"
          ),
          
          infoBox(
            title = "",
            width = 6,
            color = "light-blue",
            icon = icon("filter"),
            value = div(
              selectInput(
                "year",
                "Select Year:",
                choices = sort(unique(df_statements$Year)),
                selected = max(df_statements$Year)
              )
            )
          ),
          
          infoBox(
            title = "",
            width = 6,
            color = "light-blue",
            icon = icon("info"),
            value = "Data from Destination British Columbia",
            subtitle = "Updated manually by TOTA."
          ),
          
          valueBoxOutput("AvgAcross3", width = 4),
          valueBoxOutput("TOHighest", width = 4),
          valueBoxOutput("TOvsBC", width = 4), #pp avg positive sentiment
          
          box(
            title = "Resident Perceptions of Tourism",
            solidHeader = TRUE,
            width = 12,
            selectInput(
              "statement",
              "Select Statement:",
              choices = unique(df_statements$Statement),
              selected = "Overall, I believe the positive impacts of tourism in my community outweigh the negative impacts",
              width = 650
            ),
            plotlyOutput("StatementsBarPlot", height = 500)
          ),
          
          box(
            title = "Resident Sentiment Over Time - Thompson Okanagan",
            solidHeader = TRUE,
            width = 12,
            plotOutput("OverTimePlot", height = 500)
          ),
          
          box(
            title = "References & Data",
            solidHeader = TRUE,
            width = 12,
            p("Destination British Columbia. Resident Preceptions of BC's Tourism Industry. https://www.destinationbc.ca/research-insights/type/resident-research/?bc-residents-public-perceptions=true")
          )
        )
      ),
  
      #TOURISM & COMMUNITY TAB ----------------------------------------------------------------------------------------------
      tabItem(
        tabName = "preceptions",
        
        tags$style(HTML("
          @media (max-width: 600px) {
            #SeasonalBarChart {height: 350px !important; }
          }"
        )),
        
        fluidRow(
          box(
            title = "Tourism & Community - How do residents perceive the amount of tourism in their community?",
            solidHeader = TRUE,
            width = 12,
            p("Understanding whether residents feel there are too many, too few, or an appropriate number of
              tourists helps assess how tourism activity is experienced by local residents throughout the year.
              The Thompson Okanagan data highlights seasonal differences in these perceptions, with summer 
              consistently having an increase of residents who feel there are too many tourists compared with other seasons.
              Comparing these results with British Columbia overall helps TOTA identify regional differences in tourism pressure, 
              monitor changes in community sentiment over time, and support informed destination management decisions"),
            style = "font-size: 18px;"
          ),
          
          infoBox(
            title = "",
            width = 6,
            color = "light-blue",
            icon = icon("filter"),
            value = div(
              selectInput(
                "year_p",
                "Select Year:",
                choices = sort(unique(df_perceptions$Year)),
                selected = max(df_perceptions$Year)
              )
            )
          ),
          
          infoBox(
            title = "",
            width = 6,
            color = "light-blue",
            icon = icon("filter"),
            value = div(
              selectInput(
                "season",
                "Select Season:",
                choices = unique(df_perceptions$Season),
                selected = "Winter (Dec - Feb)"
              )
            )
          ),
          
          valueBoxOutput("TooMany", width = 3),
          valueBoxOutput("JustRight", width = 3),
          valueBoxOutput("TooFew", width = 3),
          valueBoxOutput("ppDiff", width = 3), #TO vs BC  too many pp
          
          uiOutput("SeasonalBarChartBox"),
          
          box(
            title = "Perceptions on Amount of Tourism in Community",
            solidHeader = TRUE,
            width = 12,
            gt_output("SeasonsTable")
          ),
          
          box(
            title = "References & Data",
            solidHeader = TRUE,
            width = 12,
            p("Destination British Columbia. Resident Preceptions of BC's Tourism Industry. https://www.destinationbc.ca/research-insights/type/resident-research/?bc-residents-public-perceptions=true")
          )
        )
      )
    ),
    footer_TOTA
  )
)