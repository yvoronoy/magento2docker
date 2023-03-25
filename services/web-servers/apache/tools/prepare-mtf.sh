#!/usr/bin/env bash

set -x
bin/magento config:set cms/wysiwyg/enabled disabled
bin/magento config:set admin/security/admin_account_sharing 1
bin/magento config:set admin/security/use_form_key 0
bin/magento config:set web/seo/use_rewrites 1
bin/magento cache:clean config full_page

vendor/bin/mftf build:project
vendor/bin/mftf generate:urn-catalog --force .idea/misc.xml
echo "MAGENTO_BASE_URL=http://magento2.test/pub/" > dev/tests/acceptance/.env
echo "MAGENTO_CLI_COMMAND_PATH=http://magento2.test/pub/" >> dev/tests/acceptance/.env
echo "MAGENTO_BACKEND_NAME=admin" >> dev/tests/acceptance/.env
echo "MAGENTO_ADMIN_USERNAME=admin" >> dev/tests/acceptance/.env
echo "MAGENTO_ADMIN_PASSWORD=123123q" >> dev/tests/acceptance/.env
echo "SELENIUM_HOST=selenium" >> dev/tests/acceptance/.env
echo "SELENIUM_PORT=4444" >> dev/tests/acceptance/.env
echo "SELENIUM_PROTOCOL=http" >> dev/tests/acceptance/.env
echo "SELENIUM_PATH=/wd/hub" >> dev/tests/acceptance/.env

cp dev/tests/acceptance/.htaccess.sample dev/tests/acceptance/.htaccess
vendor/bin/mftf generate:tests
vendor/bin/mftf run:test AdminLoginSuccessfulTest --remove
