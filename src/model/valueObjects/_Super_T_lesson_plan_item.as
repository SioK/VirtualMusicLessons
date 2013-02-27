/**
 * This is a generated class and is not intended for modification.  To customize behavior
 * of this value object you may modify the generated sub-class of this class - T_lesson_plan_item.as.
 */

package model.valueObjects
{
import com.adobe.fiber.services.IFiberManagingService;
import com.adobe.fiber.valueobjects.IValueObject;
import flash.events.EventDispatcher;
import mx.collections.ArrayCollection;
import mx.events.PropertyChangeEvent;

import flash.net.registerClassAlias;
import flash.net.getClassByAlias;
import com.adobe.fiber.core.model_internal;
import com.adobe.fiber.valueobjects.IPropertyIterator;
import com.adobe.fiber.valueobjects.AvailablePropertyIterator;

use namespace model_internal;

[Managed]
[ExcludeClass]
public class _Super_T_lesson_plan_item extends flash.events.EventDispatcher implements com.adobe.fiber.valueobjects.IValueObject
{
    model_internal static function initRemoteClassAliasSingle(cz:Class) : void
    {
    }

    model_internal static function initRemoteClassAliasAllRelated() : void
    {
    }

    model_internal var _dminternal_model : _T_lesson_plan_itemEntityMetadata;
    model_internal var _changedObjects:mx.collections.ArrayCollection = new ArrayCollection();

    public function getChangedObjects() : Array
    {
        _changedObjects.addItemAt(this,0);
        return _changedObjects.source;
    }

    public function clearChangedObjects() : void
    {
        _changedObjects.removeAll();
    }

    /**
     * properties
     */
    private var _internal_t_lesson_plan_item_id : int;
    private var _internal_user_id : int;
    private var _internal_lesson_id : int;
    private var _internal_x_position : int;
    private var _internal_y_position : int;
    private var _internal_display_index : int;

    private static var emptyArray:Array = new Array();


    /**
     * derived property cache initialization
     */
    model_internal var _cacheInitialized_isValid:Boolean = false;

    model_internal var _changeWatcherArray:Array = new Array();

    public function _Super_T_lesson_plan_item()
    {
        _model = new _T_lesson_plan_itemEntityMetadata(this);

        // Bind to own data or source properties for cache invalidation triggering

    }

    /**
     * data/source property getters
     */

    [Bindable(event="propertyChange")]
    public function get t_lesson_plan_item_id() : int
    {
        return _internal_t_lesson_plan_item_id;
    }

    [Bindable(event="propertyChange")]
    public function get user_id() : int
    {
        return _internal_user_id;
    }

    [Bindable(event="propertyChange")]
    public function get lesson_id() : int
    {
        return _internal_lesson_id;
    }

    [Bindable(event="propertyChange")]
    public function get x_position() : int
    {
        return _internal_x_position;
    }

    [Bindable(event="propertyChange")]
    public function get y_position() : int
    {
        return _internal_y_position;
    }

    [Bindable(event="propertyChange")]
    public function get display_index() : int
    {
        return _internal_display_index;
    }

    public function clearAssociations() : void
    {
    }

    /**
     * data/source property setters
     */

    public function set t_lesson_plan_item_id(value:int) : void
    {
        var oldValue:int = _internal_t_lesson_plan_item_id;
        if (oldValue !== value)
        {
            _internal_t_lesson_plan_item_id = value;
        }
    }

    public function set user_id(value:int) : void
    {
        var oldValue:int = _internal_user_id;
        if (oldValue !== value)
        {
            _internal_user_id = value;
        }
    }

    public function set lesson_id(value:int) : void
    {
        var oldValue:int = _internal_lesson_id;
        if (oldValue !== value)
        {
            _internal_lesson_id = value;
        }
    }

    public function set x_position(value:int) : void
    {
        var oldValue:int = _internal_x_position;
        if (oldValue !== value)
        {
            _internal_x_position = value;
        }
    }

    public function set y_position(value:int) : void
    {
        var oldValue:int = _internal_y_position;
        if (oldValue !== value)
        {
            _internal_y_position = value;
        }
    }

    public function set display_index(value:int) : void
    {
        var oldValue:int = _internal_display_index;
        if (oldValue !== value)
        {
            _internal_display_index = value;
        }
    }

    /**
     * Data/source property setter listeners
     *
     * Each data property whose value affects other properties or the validity of the entity
     * needs to invalidate all previously calculated artifacts. These include:
     *  - any derived properties or constraints that reference the given data property.
     *  - any availability guards (variant expressions) that reference the given data property.
     *  - any style validations, message tokens or guards that reference the given data property.
     *  - the validity of the property (and the containing entity) if the given data property has a length restriction.
     *  - the validity of the property (and the containing entity) if the given data property is required.
     */


    /**
     * valid related derived properties
     */
    model_internal var _isValid : Boolean;
    model_internal var _invalidConstraints:Array = new Array();
    model_internal var _validationFailureMessages:Array = new Array();

    /**
     * derived property calculators
     */

    /**
     * isValid calculator
     */
    model_internal function calculateIsValid():Boolean
    {
        var violatedConsts:Array = new Array();
        var validationFailureMessages:Array = new Array();

        var propertyValidity:Boolean = true;

        model_internal::_cacheInitialized_isValid = true;
        model_internal::invalidConstraints_der = violatedConsts;
        model_internal::validationFailureMessages_der = validationFailureMessages;
        return violatedConsts.length == 0 && propertyValidity;
    }

    /**
     * derived property setters
     */

    model_internal function set isValid_der(value:Boolean) : void
    {
        var oldValue:Boolean = model_internal::_isValid;
        if (oldValue !== value)
        {
            model_internal::_isValid = value;
            _model.model_internal::fireChangeEvent("isValid", oldValue, model_internal::_isValid);
        }
    }

    /**
     * derived property getters
     */

    [Transient]
    [Bindable(event="propertyChange")]
    public function get _model() : _T_lesson_plan_itemEntityMetadata
    {
        return model_internal::_dminternal_model;
    }

    public function set _model(value : _T_lesson_plan_itemEntityMetadata) : void
    {
        var oldValue : _T_lesson_plan_itemEntityMetadata = model_internal::_dminternal_model;
        if (oldValue !== value)
        {
            model_internal::_dminternal_model = value;
            this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "_model", oldValue, model_internal::_dminternal_model));
        }
    }

    /**
     * methods
     */


    /**
     *  services
     */
    private var _managingService:com.adobe.fiber.services.IFiberManagingService;

    public function set managingService(managingService:com.adobe.fiber.services.IFiberManagingService):void
    {
        _managingService = managingService;
    }

    model_internal function set invalidConstraints_der(value:Array) : void
    {
        var oldValue:Array = model_internal::_invalidConstraints;
        // avoid firing the event when old and new value are different empty arrays
        if (oldValue !== value && (oldValue.length > 0 || value.length > 0))
        {
            model_internal::_invalidConstraints = value;
            _model.model_internal::fireChangeEvent("invalidConstraints", oldValue, model_internal::_invalidConstraints);
        }
    }

    model_internal function set validationFailureMessages_der(value:Array) : void
    {
        var oldValue:Array = model_internal::_validationFailureMessages;
        // avoid firing the event when old and new value are different empty arrays
        if (oldValue !== value && (oldValue.length > 0 || value.length > 0))
        {
            model_internal::_validationFailureMessages = value;
            _model.model_internal::fireChangeEvent("validationFailureMessages", oldValue, model_internal::_validationFailureMessages);
        }
    }


}

}
