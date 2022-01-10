<?php
/**
 * @author         Pierre-Henry Soria <hello@ph7cms.com>
 * @copyright      (c) 2012-2019, Pierre-Henry Soria. All Rights Reserved.
 * @license        MIT License; See PH7.LICENSE.txt and PH7.COPYRIGHT.txt in the root directory.
 * @package        PH7 / App / System / Module / Forum / Form / Processing
 */

namespace PH7;

defined('PH7') or exit('Restricted access');

use PH7\Framework\Mvc\Model\Engine\Db;
use PH7\Framework\Mvc\Router\Uri;
use PH7\Framework\Url\Header;

class CategoryFormProcess extends Form
{
    public function __construct()
    {
        parent::__construct();

        (new ForumModel)->addCategory($this->httpRequest->post('title'));

        Header::redirect(
            Uri::get('forum', 'admin', 'addforum', Db::getInstance()->lastInsertId()),
            t('Category Name added!')
        );
    }
}
