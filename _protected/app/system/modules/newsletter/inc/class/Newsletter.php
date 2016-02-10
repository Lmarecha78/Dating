<?php
/**
 * @author         Pierre-Henry Soria <hello@ph7cms.com>
 * @copyright      (c) 2012-2016, Pierre-Henry Soria. All Rights Reserved.
 * @license        GNU General Public License; See PH7.LICENSE.txt and PH7.COPYRIGHT.txt in the root directory.
 * @package        PH7 / App / System / Module / Newsletter / Inc / Class
 */
namespace PH7;
defined('PH7') or exit('Restricted access');

use PH7\Framework\Mvc\Request\Http, PH7\Framework\Mail\Mail;

/** Reset the time limit and increase the memory **/
@set_time_limit(0);
@ini_set('memory_limit', '528M');

class Newsletter extends Core
{

    private $_oSubscriptionModel;
    private static $_iTotalSent = 0;

    public function __construct()
    {
        parent::__construct();

        $this->_oSubscriptionModel = new SubscriptionModel;
    }

    /**
     * Send the newsletter to subscribers.
     *
     * @return array (integer | integer) ['status', 'nb_mail_sent']
     */
    public function sendMessages()
    {
        $bOnlySubscribers = $this->httpRequest->postExists('only_subscribers');
        $iRes = 0; // Default value

        $sSubscribersMethod = ($bOnlySubscribers) ? 'getSubscribers' : 'getProfiles';
        $oSubscribers = $this->_oSubscriptionModel->$sSubscribersMethod();

        $oMail = new Mail;
        foreach ($oSubscribers as $oSubscriber)
        {
            if (!$this->sendMail($oSubscriber, $oMail)) break;

            // Do not send all emails at the same time to avoid overloading the mail server.
            if (++self::$_iTotalSent > 250) sleep(10);
        }
        unset($oMail, $oSubscribers);

        return ['status' => $iRes, 'nb_mail_sent' => self::$_iTotalSent];
    }

    /**
     * Send the newsletter to the subscribers.
     *
     * @param object $oSubscriber Subscriber data fron the DB.
     * @param object \PH7\Framework\Mail\Mail $oMail
     * @return integer Number of recipients who were accepted for delivery.
     */
    protected function sendMail($oSubscriber, Mail $oMail)
    {
        $this->view->content = $this->httpRequest->post('body', Http::NO_CLEAN);

        $sMsgHtml = $this->view->parseMail(PH7_PATH_SYS . 'global/' . PH7_VIEWS . PH7_TPL_NAME . '/mail/sys/mod/newsletter/msg.tpl', $oSubscriber->email);

        $aInfo = [
            'subject' => $this->httpRequest->post('subject'),
            'to' => $oSubscriber->email,
            'to_name' => $oSubscriber->firstName
        ];

        return $oMail->send($aInfo, $sMsgHtml);
    }

}
