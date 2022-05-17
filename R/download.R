# This file downloads the current release from gencode 
library(rvest)
library(fs)

options(timeout=5000) # download timeout 
out <- "cache/"
URL <- "https://www.gencodegenes.org/human/" 

fs::dir_create(out)
href <- rvest::read_html(URL) |> html_elements("a") |> html_attr("href") # get the latest gencode release
URL = href[grepl(href, pattern = "https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_[0-9]+/gencode.v[0-9]+.annotation.gtf.gz")] # for now, only interested in main annotation file
attempts=0
download_failure= TRUE
# the FTP site for gencode often has down time. This while loop allows the script to try to download the desired file multiple times. If the download is unsucessful after many attepts, the script will exit.
while(download_failure) {
	download_failure = FALSE
	attempts = attempts + 1

	completion <- try(download.file(URL, paste0(out, basename(URL))))

	if(is(completion, "try-error")) {
		Sys.sleep(300) # Wait 5 minutes and then try again.
		download_failure = TRUE
	}

	if(attempts > 15)
		break
}















