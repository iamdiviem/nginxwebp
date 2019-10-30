## How it works?
For example we have an original image, located there https://test.com/images/horse.jpg
When user sending request for this file, Nginx Web Server will be looking for exists alternative file with _.webp_ extension, if success, Nginx will response with content and header of alternative _.webp_ file instead original.
This's will be work for images with following extension: _.jpg, .jpeg, .png_ 

#####1. Install webp library on your Linux
CentOS: 
    `yum install libwebp-tools`
    
Ubuntu:
    `sudo apt-get install webp`
    
#####2. Copy _nginxwebp_ script of this package in to your server
`cp /bin/nginxwebp.sh /bin/nginxwebp.sh`

`chmod +x /bin/nginxwebp.sh`

#####3. Edit your Nginx configuration file 
You should to find your active _.conf_ file and edit the _server_ section.
Usually _.conf_ file is located  in _/etc/nginx/conf.d/default.conf_ but your path may be another.
Copy the contents (marked by comments) from _/etc/nginx/conf.d/default.conf_ (this packages file) in to your Nginx _.conf_ _server_ section.

#####4. Start the image conversion processing for the desired directory
`nginxwebp /your/desired/directory/`

#####5. Add the processing script in your task scheduler
This is example of task, starting every 12 hours.

Cron:  
`* */12 * * * nginxwebp /your/desired/directory/ >> /var/log/cron/cron_nginxwebp.log 2>&1`

#####6. Enjoy! :)