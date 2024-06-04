# Install the vcfR package (uncomment if not already installed)
# install.packages("vcfR")
#install.packages("vcfR")

# Load required libraries
library(vcfR)
library(ggplot2)

# Set working directory to vcf files located folder
setwd("E:/study/5030Bio-computing/project/visualization")

# Create an empty list to store VCF data for each generation
# vcfR:
# meta:‘#’号开头行
# fix:染色体编号、碱基位置、ID、参考碱基、变异碱基、质量值、是否过滤
# gt:format、样本基因型
mouse <- list()

# Loop through generations 1 to 10, read vcf files to the list
for (gen in 1:10) {
        # Construct the VCF file name for each generation
        vcf_file  <- paste0("m2_p", gen, "_anc.freebayes.q30.vcf")
        
        # Read the VCF file and store it in the list
        mouse[[gen]] <- read.vcfR(vcf_file)
}

# Create an empty list to store variant info for each generation
variant_list <- list()

# Extract the last column from the fixed part of each VCF object and process it
for (gen in 1:10) {
        last_column <- mouse[[gen]]@fix[, ncol(mouse[[gen]])] # Get the last column
        variant_info <- strsplit(last_column, "[;]") # Split the column by ';'
        
        # Extract the type of variant
        type <- sapply(variant_info, function(variant) variant[length(variant)])
        type <- substr(type, 6, nchar(type))
        
        # Append the variant type to the list
        variant_list <- append(variant_list, list(type))
}

# Create a list of your vectors
allVectors <- variant_list

# Initialize an empty matrix
resultMatrix <- matrix(nrow = 0, ncol = 3, dimnames = list(NULL, c("variant", "frequency", "generation")))

# Loop through each vector in the list
for (i in seq_along(allVectors)) {
        # Count the frequency of each element
        freqTable <- table(allVectors[[i]])
        
        # Create a matrix with the results
        vectorMatrix <- cbind(content = names(freqTable), frequency = as.numeric(freqTable), vector_name = i)
        
        # Combine with the overall result
        resultMatrix <- rbind(resultMatrix, vectorMatrix)
        plot_data <- data.frame(resultMatrix)
}

# Conver frequency to numeric type
plot_data$frequency <- as.numeric(plot_data$frequency)

# Define the order of generation for the plot
col_order <- c('1','2','3','4','5','6','7','8','9','10')
plot_data$generation <- factor(plot_data$gene,levels = col_order)

# Print the result
# print(resultMatrix)

# Create the plot using ggplot2
q1<-ggplot(data=plot_data, mapping=aes(x = generation, y = frequency, fill = variant))+
        geom_bar(stat="identity",position="stack") + 
        theme(axis.text.x = element_text(size = 15), axis.text.y = element_text(size = 15)) +
        theme(axis.title.x = element_text(size = 15), axis.title.y = element_text(size = 15))

# Save the plot as a PDF file
pdf(file = "E:/study/5030Bio-computing/project/visualization/m2_all_gen.pdf")
q1
dev.off()