server <- function(input, output, session) {
  #TOURISM INDUSTRY TAB ========================================================================================== 
  #VALUEBOX FOR AVG % OF ALL 3 SATEMENTS -------------------------------------------------------------------------
  output$AvgAcross3 <- renderValueBox({
    all <- df_statements %>%
      filter(Year == input$year, Region == "Thompson Okanagan")
    
    sum_all <- sum(all$Value)
    
    avg <- (sum_all/nrow(all))
    
    valueBox(
      value = paste0(round(avg, 2), "%"),
      subtitle = paste0("Thompson Okanagan avg of all 3 statements - ", input$year),
      icon = icon("percent"),
      color = "orange"
    )
  })
  
  #VALUEBOX T-O HIGHEST SCORE  -----------------------------------------------------------------------------------
  output$TOHighest <- renderValueBox({
    
    all <- df_statements %>%
      filter(Year == input$year, Region == "Thompson Okanagan") %>%
      filter(Value == max(Value))
    
    state <- if(all$Statement == "Overall, I believe the positive impacts of tourism in my community outweigh the negative impacts"){
      "positive impacts statement"
    }else if(all$Statement == "Overall, tourism contributes positively to the quality of life of my community"){
      "quality of life statement"
    }else{
      "amenities statement"
    }
    
    valueBox(
      value = paste0(round(all$Value, 2), "%"),
      subtitle = paste0("TO's highest score, ", state, " - ", input$year),
      icon = icon("ranking-star"),
      color = "teal"
    )
  })
  
  #VALUEBOX AVG PP TO vs. BC -------------------------------------------------------------------------------------
  output$TOvsBC <- renderValueBox({
    
    TO <- df_statements %>%
      filter(Year == input$year, Region == "Thompson Okanagan")
    
    avg_TO <- mean(TO$Value, na.rm = TRUE)
    
    BC <- df_statements %>%
      filter(Year == input$year, Region == "British Columbia")
    
    avg_BC <- mean(BC$Value, na.rm = TRUE)
    
    diff_pp <- avg_TO - avg_BC
    
    if (diff_pp > 0) {
      valueBox(
        value = paste0("+", round(diff_pp, 1), " pp"),
        subtitle = paste0("TO average positive sentiment higher than BC - ", input$year),
        icon = icon("plus"),
        color = "orange"
      )
    } else if (diff_pp < 0) {
      valueBox(
        value = paste0(round(diff_pp, 1), " pp"),
        subtitle = paste0("TO average positive sentiment lower than BC - ", input$year),
        icon = icon("minus"),
        color = "orange"
      )
    } else {
      valueBox(
        value = "0 pp",
        subtitle = paste0("TO and BC average positive sentiment equal - ", input$year),
        icon = icon("slash"),
        color = "orange"
      )
    }
  })
  
  #COMPARE STATEMENTS BAR CHART ----------------------------------------------------------------------------------
  output$StatementsBarPlot <- renderPlotly({
    
    plot_width <- session$clientData$output_StatementsBarPlot_width
    is_narrow <- !is.null(plot_width) && plot_width < 600
    
    df_statements_filtered <- df_statements %>%
      filter(Year == input$year, Statement == input$statement)
      
    plot <- ggplot(df_statements_filtered, aes(x = reorder(Region, Value, decreasing = TRUE),
                                       y = Value)) + 
      geom_col(fill = ifelse(df_statements_filtered$Region == "British Columbia", "#BCB49E", ifelse(df_statements_filtered$Region == "Thompson Okanagan", "#004B55", "#76ACA9")),
                      width = 0.35) +
     
      geom_text(
         aes(label = paste0(Value, "%")),
         nudge_y = 2,
         color = "#878787",
         size = if (is_narrow) 3.5 else 5
       ) +
      
      scale_x_discrete(
        labels = c(
          "British Columbia" = "British<br>Columbia",
          "Vancouver, Coast & Mountains" = "Vancouver,<br>Coast &<br>Mountains",
          "Vancouver Island" = "Vancouver<br>Island",
          "Thompson Okanagan" = "Thompson<br>Okanagan",
          "Kootenay Rockies" = "Kootenay<br>Rockies",
          "Northern BC" = "Northern BC",
          "Cariboo Chilcotin Coast" = "Cariboo<br>Chilcotin<br>Coast"
        ),
        expand = expansion(mult = c(0.1, 0.1))
      )+
     
      scale_y_continuous(
        labels = function(x) paste0(x, "%")
      ) +
      
      labs(
        x = "Region", 
        y = "(% Strongly Agree / Agree)"
      ) +
      
      theme_minimal()+
      
      theme(axis.title = element_text(size = if (is_narrow) 10 else 16),
            axis.text = element_text(size = if (is_narrow) 8 else 12),
            axis.text.x = element_text(angle = if (is_narrow) 60 else 0))
    
   ggplotly(plot) %>%
     style(hoverinfo = 'none') %>%
     layout(
       margin = list(l = ifelse(is_narrow, 45, 100), r = 10, t = 0, b = 50)
     ) %>%
     config(displayModeBar = FALSE)
  })
  
  #COMPARE TO % OVER TIME FOR ALL # STATEMENTS -------------------------------------------------------------------
  output$OverTimePlot <- renderPlot({
    
    plot_width <- session$clientData$output_OverTimePlot_width
    is_narrow <- !is.null(plot_width) && plot_width < 600

    df_statements_filtered <- df_statements %>%
      filter(Region == "Thompson Okanagan")
    
    ggplot(df_statements_filtered, aes(x = Year, y = Value, 
                                              group = Statement, 
                                              color = Statement,
                                              text = paste0(Value, "%"))) +
      geom_line(linewidth = 1.5)+
      
      scale_color_manual(
        name = "Resident Perceptions",
        values = c(
          "Overall, I believe the positive impacts of tourism in my community outweigh the negative impacts" = "#004B55",
          "Overall, tourism contributes positively to the quality of life of my community" = "#76ACA9",
          "Tourism supports a greater diversity of amenities than would otherwise exist in my community" = "#F6BC1A"
        ),
        labels = c(
          "Positive impacts outweigh negatives",
          "Tourism improves quality of life",
          "Tourism supports more amenities"
        ),
        guide = guide_legend(ncol = 1)
      ) +
      
      scale_x_continuous(
        breaks = sort(unique(df_statements_filtered$Year)),
        expand = expansion(mult = c(0, 0.03))
      ) +
      
      scale_y_continuous(
        breaks = scales::breaks_pretty(n = 5),
        labels = function(x) paste0(x, "%")
      ) +
      
      labs(
        x = "",
        y = "(% Strongly Agree / Agree)"
      ) +
      
      theme_minimal() +
      
      theme(axis.title = element_text(size = if (is_narrow) 10 else 18),
            axis.text = element_text(size = if (is_narrow) 8 else 16),
            legend.title = element_text(size = if (is_narrow) 10 else 14),
            legend.text = element_text(size = if (is_narrow) 10 else 12),
            legend.position = "top",
            legend.direction = "vertical",
            legend.location = "plot",
            legend.justification = "left")
  }, res = 97)
  
  #TOURISM & COMMUNITY TAB ---------------------------------------------------------------------------------------
  #VALUE BOX FOR TOO MANY TOURISTS -------------------------------------------------------------------------------
  output$TooMany <- renderValueBox({
    tooMany <- df_perceptions %>%
      filter(Year == input$year_p, Season == input$season, Region == "Thompson Okanagan", Perceptions == "Too many")
    
    valueBox(
      value = paste0(tooMany$Value, "%"),
      subtitle = paste0("Too many tourists, ", tooMany$Region, " - ", input$year_p),
      icon = icon("people-group"),
      color = "orange"
    )
  })
  
  #VALUE BOX FOR JUST RIGHT AMOUNT OF TOURISTS -------------------------------------------------------------------
  output$JustRight <- renderValueBox({
    
    justRight <- df_perceptions %>%
      filter(Year == input$year_p, Season == input$season, Region == "Thompson Okanagan", Perceptions == "Just the right amount")
    
    valueBox(
      value = paste0(justRight$Value, "%"),
      subtitle = paste0("Just the right amount, ", justRight$Region, " - ", input$year_p),
      icon = icon("thumbs-up"),
      color = "teal"
    )
  })
  
  #VALUE BOX TOO FEW TOURISTS ------------------------------------------------------------------------------------
  output$TooFew <- renderValueBox({
    tooFew <- df_perceptions %>%
      filter(Year == input$year_p, Season == input$season, Region == "Thompson Okanagan", Perceptions == "Too few")
    
    valueBox(
      value = paste0(tooFew$Value, "%"),
      subtitle = paste0("Too few tourists, ", tooFew$Region, " - ", input$year_p),
      icon = icon("users-slash"),
      color = "orange"
    )
  })
  
  #VALUE PP JUST RIGHT AMOUNT TO VS. BC TOURISTS -----------------------------------------------------------------
  output$ppDiff <- renderValueBox({
    
    TO <- df_perceptions %>%
      filter(Year == input$year_p, Season == input$season, Region == "Thompson Okanagan", Perceptions == "Just the right amount") %>%
      pull(Value)
    
    BC <- df_perceptions %>%
      filter(Year == input$year_p, Season == input$season, Region == "British Columbia", Perceptions == "Just the right amount") %>%
      pull(Value)
    
    diff_pp <- TO - BC
    
    if (diff_pp > 0) {
      valueBox(
        value = paste0("+", round(diff_pp, 1), " pp"),
        subtitle = paste0("Difference from BC, just the right amount - ", input$year_p),
        icon = icon("plus"),
        color = "teal"
      )
    } else if (diff_pp < 0) {
      valueBox(
        value = paste0(round(diff_pp, 1), " pp"),
        subtitle = paste0("Difference from BC, just the right amount - ", input$year_p),
        icon = icon("minus"),
        color = "teal"
      )
    } else {
      valueBox(
        value = "0 pp",
        subtitle = paste0("Difference from BC, just the right amount - ", input$year_p),
        icon = icon("slash"),
        color = "teal"
      )
    }
  })
  
  #COMPARE SEASONS WITH 100% STACKED BAR CHART -------------------------------------------------------------------
  output$SeasonalBarChart <- renderPlot({
    
    plot_width <- session$clientData$output_SeasonalBarChart_width
    is_narrow <- !is.null(plot_width) && plot_width < 600
    
    df_seasons <- df_perceptions %>%
      filter(Year == input$year_p, Region == "Thompson Okanagan")
    
    ggplot(df_seasons, aes(x = factor(Season, levels = c("Winter (Dec - Feb)", "Spring (Mar - May)", "Summer (Jun - Aug)", "Fall (Sep - Nov)")),
                           y = Value,
                           fill = Perceptions)) +
      geom_bar(position = "stack", stat = "identity", width = 0.5) +
      
      geom_text(
        aes(label = paste0(Value, "%")),
        position = position_stack(vjust = 0.5),
        color = "white",
        size = if (is_narrow) 3 else 5.5
      ) +
      
      scale_fill_manual(
        name = "Resident Perceptions",
        values = c(
          "Too many" = "#F6BC1A",
          "Just the right amount" = "#76ACA9",
          "Too few" = "#004B55"
        ),
        guide = guide_legend(ncol = 1)
      ) +
      
      scale_x_discrete(
        expand = if(is_narrow) expansion(mult = c(0, 0)) else expansion(mult = c(0.25, 0.25))
      ) +
      
      scale_y_continuous(
        breaks = scales::breaks_pretty(n = 5),
        labels = function(x) paste0(x, "%")
      ) +
      
      labs(
        x = "",
        y = "(% Strongly Agree / Agree)"
      ) +
      
      theme_minimal() +
      
      theme(axis.title = element_text(size = if (is_narrow) 10 else 18),
            axis.text = element_text(size = if (is_narrow) 8 else 16),
            axis.text.x = element_text(angle = if (is_narrow) 60 else 0, hjust = if(is_narrow) 0.9 else 0.5),
            legend.title = element_text(size = if (is_narrow) 8 else 14),
            legend.text = element_text(size = if (is_narrow) 8 else 12),
            legend.position = if(is_narrow) "top" else "right",
            legend.direction = "vertical",
            legend.location = "plot",
            legend.justification = "center")
    
  }, res = 97)
  
  #DYNAMIC BOX FOR SLECTED YEAR-----------------------------------------------------------------------------------
  output$SeasonalBarChartBox <- renderUI ({
    box(
      title = paste0("Thompson Okanagan Seasonal Perceptions of Tourism - ", input$year_p),
      solidHeader = TRUE,
      width = 12,
      plotOutput("SeasonalBarChart", height = 500)
    )
  })        

  #PERCEPTIONS TABLE ---------------------------------------------------------------------------------------------
  output$SeasonsTable <- render_gt({
    
    df_perceptions %>%
      filter(
        Year == input$year_p,
        Region %in% c("British Columbia", "Thompson Okanagan")
      ) %>%
      mutate(
        Season = factor(
          Season,
          levels = c(
            "Winter (Dec - Feb)",
            "Spring (Mar - May)",
            "Summer (Jun - Aug)",
            "Fall (Sep - Nov)"
          )
        ),
        Perceptions = factor(
          Perceptions,
          levels = c(
            "Too many",
            "Just the right amount",
            "Too few"
          )
        )
      ) %>%
      select(Season, Perceptions, Region, Value) %>%
      pivot_wider(
        names_from = Region,
        values_from = Value
      ) %>%
      gt(
        rowname_col = "Perceptions",
        groupname_col = "Season"
      ) %>%
      tab_stubhead(label = as.character(input$year_p)) %>%
      cols_label(
        `British Columbia` = html( "British<br>Columbia"),
        `Thompson Okanagan` = html("Thompson<br>Okanagan")
      ) %>%
      fmt(
        columns = c(`British Columbia`, `Thompson Okanagan`),
        fns = function(x) paste0(x, "%")
      ) %>%
      tab_options(
        table.font.size = px(16),
        row_group.font.weight = "bold",
        row_group.background.color = "#F0F0F0",
        column_labels.background.color = "#76ACA9",
        column_labels.font.weight = "bold",
        data_row.padding = px(8),
      ) %>%
      tab_style(
        style = cell_text(align = "center"),
        locations = cells_column_labels()
      )
  })
  
  #OVERVIEW PAGE =================================================================================================
  #CLICKABLE LINK FOR TOURISM INDUSTRY TAB -----------------------------------------------------------------------
  observeEvent(input$statements_link, {
    updateTabItems(session, "tabs", "statements")
  })
  
  #CLICKABLE LINK FOR TOURISM & COMMUNITY TAB --------------------------------------------------------------------
  observeEvent(input$preceptions_link, {
    updateTabItems(session, "tabs", "preceptions")
  })

}
