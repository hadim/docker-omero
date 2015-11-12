if [ $OMERO_WEB_USE_SSL == "yes" ]
then

    # Setup nginx for ssl
    echo "Enable https for OMERO.web"
    ln -s /etc/nginx/sites-available/nginx_omero_ssl.conf /etc/nginx/sites-enabled/

else
    # Setup nginx without ssl
    ln -s /etc/nginx/sites-available/nginx_omero.conf /etc/nginx/sites-enabled/
fi

/usr/sbin/nginx
