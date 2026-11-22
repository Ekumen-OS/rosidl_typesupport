// generated from rosidl_typesupport_cpp/resource/idl__region_type_support.cpp.em
// with input from @(package_name):@(interface_path)
// generated code does not contain a copyright notice
@{
from rosidl_generator_c import idl_structure_type_to_c_typename
from rosidl_generator_type_description import GET_DESCRIPTION_FUNC, GET_HASH_FUNC, GET_SOURCES_FUNC
from rosidl_parser.definition import Message, Service
from rosidl_pycommon import convert_camel_case_to_lower_case_underscore

messages = list(content.get_elements_of_type(Message))
services = content.get_elements_of_type(Service)
for service in services:
    messages.extend([service.request_message, service.response_message])
parts = [package_name] + list(interface_path.parents[0].parts)
stem = convert_camel_case_to_lower_case_underscore(interface_path.stem)
}@
@[if messages]@
#include "@('/'.join(parts))/views/@(stem)__region.hpp"
@[if len(type_supports) == 1]@
#include "@('/'.join(parts))/views/detail/@(stem)__rosidl_typesupport_xcdr_cpp.hpp"
@[else]@
#include "@('/'.join(parts))/detail/@(stem)__functions.h"
#include "rosidl_typesupport_c/type_support_map.h"
#include "rosidl_typesupport_cpp/identifier.hpp"
#include "rosidl_typesupport_cpp/message_type_support_dispatch.hpp"
@[if services]@
#include "rosidl_typesupport_cpp/service_type_support_dispatch.hpp"
@[end if]@
@[end if]@
#include "rosidl_typesupport_cpp/message_type_support.hpp"
@[if services]@
#include "rosidl_typesupport_cpp/service_type_support.hpp"
@[end if]@
#include "rosidl_typesupport_cpp/visibility_control.h"
#include "rosidl_typesupport_interface/macros.h"

#define STRINGIFY_REGION_(s) #s
#define STRINGIFY_REGION(s) STRINGIFY_REGION_(s)

@[for message in messages]@
@{
name = message.structure.namespaced_type.name
c_name = idl_structure_type_to_c_typename(message.structure.namespaced_type)
view_type = '::'.join(parts + ['views', name + 'RegionView<true>'])
symbol_parts = [package_name, interface_path.parents[0].name + '_views']
}@
@[if len(type_supports) != 1]@
namespace @('::'.join(parts + ['views']))
{
namespace rosidl_typesupport_cpp
{

static const char * @(name)_identifiers[] = {"rosidl_typesupport_xcdr_cpp"};
static const char * @(name)_symbols[] = {
  STRINGIFY_REGION(ROSIDL_TYPESUPPORT_INTERFACE__MESSAGE_SYMBOL_NAME(
    rosidl_typesupport_xcdr_cpp, @(', '.join(symbol_parts)), @(name)))
};
static void * @(name)_data[] = {nullptr};
static const type_support_map_t @(name)_map = {
  1, "@(package_name)", @(name)_identifiers, @(name)_symbols, @(name)_data
};
static const rosidl_message_type_support_t @(name)_handle = {
  ::rosidl_typesupport_cpp::typesupport_identifier,
  &@(name)_map,
  ::rosidl_typesupport_cpp::get_message_typesupport_handle_function,
  &@(c_name)__@(GET_HASH_FUNC),
  &@(c_name)__@(GET_DESCRIPTION_FUNC),
  &@(c_name)__@(GET_SOURCES_FUNC)
};

}  // namespace rosidl_typesupport_cpp
}  // namespace @('::'.join(parts + ['views']))
@[end if]@

namespace rosidl_typesupport_cpp
{
template<>
ROSIDL_TYPESUPPORT_CPP_PUBLIC
const rosidl_message_type_support_t *
get_message_type_support_handle<@(view_type)>()
{
@[if len(type_supports) == 1]@
  return ROSIDL_TYPESUPPORT_INTERFACE__MESSAGE_SYMBOL_NAME(
    rosidl_typesupport_xcdr_cpp, @(', '.join(symbol_parts)), @(name))();
@[else]@
  return &::@('::'.join(parts + ['views']))::rosidl_typesupport_cpp::@(name)_handle;
@[end if]@
}

extern "C" ROSIDL_TYPESUPPORT_CPP_PUBLIC
const rosidl_message_type_support_t *
ROSIDL_TYPESUPPORT_INTERFACE__MESSAGE_SYMBOL_NAME(
  rosidl_typesupport_cpp, @(', '.join(symbol_parts)), @(name))()
{
  return get_message_type_support_handle<@(view_type)>();
}
}  // namespace rosidl_typesupport_cpp
@[end for]@
@[for service in services]@
@{
name = service.namespaced_type.name
c_name = idl_structure_type_to_c_typename(service.namespaced_type)
view_service = '::'.join(parts + ['views', 'Region' + name])
symbol_parts = [package_name, interface_path.parents[0].name + '_views']
request_type = '::'.join(parts + ['views', name + '_RequestRegionView<true>'])
response_type = '::'.join(parts + ['views', name + '_ResponseRegionView<true>'])
event_type = '::'.join(parts + [name + '_Event'])
}@
@[if len(type_supports) != 1]@
namespace @('::'.join(parts + ['views']))
{
namespace rosidl_typesupport_cpp
{

static const char * @(name)_service_identifiers[] = {"rosidl_typesupport_xcdr_cpp"};
static const char * @(name)_service_symbols[] = {
  STRINGIFY_REGION(ROSIDL_TYPESUPPORT_INTERFACE__SERVICE_SYMBOL_NAME(
    rosidl_typesupport_xcdr_cpp, @(', '.join(symbol_parts)), @(name)))
};
static void * @(name)_service_data[] = {nullptr};
static const type_support_map_t @(name)_service_map = {
  1, "@(package_name)", @(name)_service_identifiers, @(name)_service_symbols, @(name)_service_data
};
static const rosidl_service_type_support_t @(name)_service_handle = {
  ::rosidl_typesupport_cpp::typesupport_identifier,
  &@(name)_service_map,
  ::rosidl_typesupport_cpp::get_service_typesupport_handle_function,
  ::rosidl_typesupport_cpp::get_message_type_support_handle<@(request_type)>(),
  ::rosidl_typesupport_cpp::get_message_type_support_handle<@(response_type)>(),
  ::rosidl_typesupport_cpp::get_message_type_support_handle<@(event_type)>(),
  nullptr,
  nullptr,
  &@(c_name)__@(GET_HASH_FUNC),
  &@(c_name)__@(GET_DESCRIPTION_FUNC),
  &@(c_name)__@(GET_SOURCES_FUNC)
};

}  // namespace rosidl_typesupport_cpp
}  // namespace @('::'.join(parts + ['views']))
@[end if]@

namespace rosidl_typesupport_cpp
{
template<>
ROSIDL_TYPESUPPORT_CPP_PUBLIC
const rosidl_service_type_support_t *
get_service_type_support_handle<@(view_service)>()
{
@[if len(type_supports) == 1]@
  return ROSIDL_TYPESUPPORT_INTERFACE__SERVICE_SYMBOL_NAME(
    rosidl_typesupport_xcdr_cpp, @(', '.join(symbol_parts)), @(name))();
@[else]@
  return &::@('::'.join(parts + ['views']))::rosidl_typesupport_cpp::@(name)_service_handle;
@[end if]@
}

extern "C" ROSIDL_TYPESUPPORT_CPP_PUBLIC
const rosidl_service_type_support_t *
ROSIDL_TYPESUPPORT_INTERFACE__SERVICE_SYMBOL_NAME(
  rosidl_typesupport_cpp, @(', '.join(symbol_parts)), @(name))()
{
  return get_service_type_support_handle<@(view_service)>();
}
}  // namespace rosidl_typesupport_cpp
@[end for]@
@[end if]@
