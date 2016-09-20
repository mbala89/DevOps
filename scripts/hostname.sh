#!/usr/bin/env bash
echo "
        Hostname change for the reference
           
	 qa1-be-mongo-01.aws.ca     => 	westqa01.findly.com
	 qa2-be-mongo-01.aws.ca     => 	westqa02.findly.com
	 qa4-be-mongo-01.aws.ca     => 	westqa04.findly.com
	 qa5-be-mongo-01.aws.ca     => 	westqa05.findly.com
	 qa6-be-mongo-01.aws.ca     => 	westqa06.findly.com
	 dev-be-mongo-01.aws.ca     => 	westqa07.findly.com
	 prod-be-mongodb-01.aws.ca  => 	west01.findly.com
	 prod-be-mongodb-02.aws.ca  => 	west02.findly.com
	 prod-be-mongodb-03.aws.ca  => 	west03.findly.com
	 uat-be-mongo-01.aws.ca     => 	westt01.findly.com
	 uat-be-mongo-02.aws.ca     => 	westt02.findly.com
	 uat-be-mongo-03.aws.ca     => 	westt03.findly.com" 

OLD_HOSTNAME="$( hostname )"
NEW_HOSTNAME="$1"
echo "Current hostname is $OLD_HOSTNAME"

if [ -z "$NEW_HOSTNAME" ]; then
 echo "Your current hostname is $OLD_HOSTNAME"
 echo -n "Please enter new hostname: "
 read NEW_HOSTNAME < /dev/tty
fi

if [ -z "$NEW_HOSTNAME" ]; then
 echo "Error: no hostname entered. Exiting."
 exit 1
fi

echo "Changing hostname from $OLD_HOSTNAME to $NEW_HOSTNAME..."

hostname "$NEW_HOSTNAME"

sed -i "s/HOSTNAME=.*/HOSTNAME=$NEW_HOSTNAME/g" /etc/sysconfig/network

if [ -n "$( grep "$OLD_HOSTNAME" /etc/hosts )" ]; then
 sed -i "s/$OLD_HOSTNAME/$NEW_HOSTNAME/g" /etc/hosts
else
 echo -e "$( hostname -I | awk '{ print $1 }' )\t$NEW_HOSTNAME" >> /etc/hosts
fi

echo "hostname is $NEW_HOSTNAME"

chmod -x /etc/rc.d/rc.local
echo "Stopped puppet agent run"
