## How it works?
For example we have an original image, located there _test.com/images/horse.jpg_
When user sending request for this file, Nginx Web Server will be looking for exists alternative file with _.webp_ extension, if success, Nginx will send response with content and header of alternative _.webp_ file instead original.
This's will be work for images with following extension: _.jpg, .jpeg, .png_ 

#####1. Install _WebP_ and _ExifTool_ libraries on your Linux
CentOS: 
    `yum install libwebp-tools perl-Image-ExifTool`
    
Debian/Ubuntu:
    `sudo apt-get install webp exiftool`
    
#####2. Copy _nginxwebp.sh_ script of this package in to your server
`cp ./bin/nginxwebp.sh /bin/nginxwebp.sh`

`chmod +x /bin/nginxwebp.sh`

#####3. Edit your _Nginx_ configuration file 
You should to find your active _.conf_ file and edit the _server_ section.
Usually _.conf_ file is located  in _/etc/nginx/conf.d/default.conf_ but your path may be another.
Copy the contents (marked by comments) from _/etc/nginx/conf.d/default.conf_ (this packages file) in to your Nginx _.conf_ _server_ section.

Dont forget to change value for _$webpdir_ variable! 

#####4. Start the image conversion processing for the desired directory
Where first param _/var/www/html_ is path of your web sites root directory, second param _wp-content/upload_ is relative path of your sites directory with images, third param _webp_ is relative path for compiled _.webp_ files and fourth param _80_ is a compression ratio (in the range of 1 to 100). 
Dont forget to insert your real paths in this command!

`nginxwebp.sh /var/www/html/ wp-content/upload webp 80`

#####5. Add the processing script in your task scheduler
This is example of task, starting every 12 hours.

Cron:  
`* */12 * * * nginxwebp.sh /var/www/html/ wp-content/upload webp 80 >> /var/log/cron/cron_nginxwebp.log 2>&1`

#####6. Enjoy! :)

## Whats doing _nginxwebp.sh_ script?
This script find all images in the given directory (second param) and via _WebP_ library make compressed (compress ratio - fourth param) _.webp_ files in the given directory for output (second param).
The search is performed recursively, repeating the structure of the source directory in the output directory. 

At the time of compression, the script receives the checksum of the source file and stores the converted _.webp_ in the meta-data of the converted _.webp_, the next time these amounts are checked, and the _.webp_ file is recreated only if they diverge.