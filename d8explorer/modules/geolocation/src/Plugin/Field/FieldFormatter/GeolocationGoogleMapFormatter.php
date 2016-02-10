<?php
/**
 * @file
 * Contains \Drupal\geolocation\Plugin\Field\FieldFormatter\GeolocationGoogleMapFormatter.
 */

namespace Drupal\geolocation\Plugin\Field\FieldFormatter;

use Drupal\Core\Field\FieldItemListInterface;
use Drupal\Core\Field\FormatterBase;
use Drupal\Core\Form\FormStateInterface;

/**
 * Plugin implementation of the 'geolocation_latlng' formatter.
 *
 * @FieldFormatter(
 *   id = "geolocation_map",
 *   module = "geolocation",
 *   label = @Translation("Geolocation Google Map"),
 *   field_types = {
 *     "geolocation"
 *   }
 * )
 */
class GeolocationGoogleMapFormatter extends FormatterBase {
  /**
   * {@inheritdoc}
   */
  public static function defaultSettings() {
    return array(
      'type' => 'ROADMAP',
      'zoom' => 10,
      'height' => '400px',
      'width' => '100%',
    ) + parent::defaultSettings();
  }

  /**
   * {@inheritdoc}
   */
  public function settingsForm(array $form, FormStateInterface $form_state) {
    $settings = $this->getSettings();
    $elements['type'] = array(
      '#type' => 'select',
      '#title' => $this->t('Default map type'),
      '#options' => $this->getMapTypes(),
      '#default_value' =>  $settings['type'],
    );
    $elements['zoom'] = array(
      '#type' => 'select',
      '#title' => $this->t('Zoom level'),
      '#options' => range(0, 18),
      '#description' => $this->t('The initial resolution at which to display the map, where zoom 0 corresponds to a map of the Earth fully zoomed out, and higher zoom levels zoom in at a higher resolution.'),
      '#default_value' => $settings['zoom'],
    );
    $elements['height'] = array(
      '#type' => 'textfield',
      '#title' => $this->t('Height'),
      '#description' => $this->t('Enter the dimensions and the measurement units. E.g. 200px or 100%.'),
      '#size' => 4,
      '#default_value' => $settings['height'],
    );
    $elements['width'] = array(
      '#type' => 'textfield',
      '#title' => $this->t('Width'),
      '#description' => $this->t('Enter the dimensions and the measurement units. E.g. 200px or 100%.'),
      '#size' => 4,
      '#default_value' => $settings['width'],
    );
    return $elements;
  }

  /**
   * {@inheritdoc}
   */
  public function settingsSummary() {
    $settings = $this->getSettings();
    $types = $this->getMapTypes();
    $summary = array();
    $summary[] = $this->t('Type: @type', array('@type' => $types[$settings['type']]));
    $summary[] = $this->t('Zoom level: @zoom', array('@zoom' => $settings['zoom']));
    $summary[] = $this->t('Height: @height', array('@height' => $settings['height']));
    $summary[] = $this->t('Width: @width', array('@width' => $settings['width']));
    return $summary;
  }

  /**
   * {@inheritdoc}
   */
  public function viewElements(FieldItemListInterface $items, $langcode) {
    // Add formatter settings to the drupalSettings array.
    $field_settings = $this->getSettings();
    $elements =  [];
    foreach ($items as $delta => $item) {
      $uniqueue_id = uniqid("map-canvas-");

      $elements[$delta] = [
        '#type' => 'markup',
        '#markup' => '<div id="' . $uniqueue_id . '" class="geolocation-google-map"></div>',
        '#attached' => [
          'library' => ['geolocation/geolocation.maps'],
          'drupalSettings' => [
            'geolocation' => [
              'maps' => [
                $uniqueue_id => [
                  'id' => "{$uniqueue_id}",
                  'lat' => (float)$item->lat,
                  'lng' => (float)$item->lng,
                  'settings' => $field_settings,
                ],
              ],
            ],
          ],
        ],
      ];
    }
    return $elements;
  }

  /**
   * An array of all available map types.
   *
   * @return array
   */
  private function getMapTypes() {
    return array(
      'ROADMAP' => $this->t('Road map view'),
      'SATELLITE' => $this->t('Google Earth satellite images'),
      'HYBRID' => $this->t('A mixture of normal and satellite views'),
      'TERRAIN' => $this->t('A physical map based on terrain information'),
    );
  }
}
