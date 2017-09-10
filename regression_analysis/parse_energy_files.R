
require(lubridate)
require(anytime)

parse_energy_files = function(root_dir){
    # load
    
    oat = NULL
    monthly_data = NULL
    monthly_oat = NULL
    merged_df = NULL
    
    init = function(root_dir){
        oat = read.csv(file.path(root_dir, 'data', 'oat.tsv'),sep='', header=F)
        names(oat) = c('month', 'day', 'year', 'OAT')
        
        oat <<- oat
        monthly_data = read.csv(file.path(root_dir,'data', 'monthly_data.csv'), header=T)
        
        
    }
      
    monthly_avg_oat = function(){
        monthly_oat = aggregate(oat['OAT'],by = list(oat$month,oat$year), mean)
        names(monthly_oat) = c('month', 'year', 'OAT')
        monthly_oat$end_date = anytime::anydate(with(monthly_oat, paste(year, month))) - lubridate::days(1)
        
        monthly_oat <<- monthly_oat[,3:4]
    }
    
    join_drop = function(){
        merged_df <<- merge(monthly_data, monthly_oat,x.by=c('End_Date'), y.by=c('end_date'))
        
    }
    
    init(root_dir)
    monthly_avg_oat()
    join_drop()

    return(merged_df)

}

parse_energy_files(getwd())
