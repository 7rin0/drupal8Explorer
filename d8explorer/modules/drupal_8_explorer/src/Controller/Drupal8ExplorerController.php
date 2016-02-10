<?php
/**
 * Created by PhpStorm.
 * User: lseverino
 * Date: 20/12/15
 * Time: 18:53
 */

namespace Drupal\drupal_8_explorer\Controller;

use Drupal\Core\Controller\ControllerBase;

/**
 * Class Drupal8ExplorerController
 *
 * @package Drupal\drupal_8_explorer\Controller
 */
class Drupal8ExplorerController extends ControllerBase
{
    /**
     * @return array
     */
    public function index()
    {
        return array(
            '#type' => 'markup',
            '#markup' => $this->t('Hello Drupal 8!'),
        );
    }
}