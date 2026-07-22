@# Included from rosidl_typesupport_cpp/resource/idl__type_support.cpp.em
@{
# Get optional force_experimental flag (set by experimental wrapper templates)
try:
    force_experimental
except NameError:
    force_experimental = False

# Get optional experimental_type_supports
try:
    experimental_type_supports
except NameError:
    experimental_type_supports = []

# Determine effective type supports for this dispatch file
if force_experimental and experimental_type_supports:
    effective_type_supports = experimental_type_supports
else:
    effective_type_supports = type_supports

# Experimental messages always use multi-typesupport dispatch to avoid
# backend include path propagation issues with single-typesupport direct includes
use_multi_typesupport = len(effective_type_supports) != 1 or force_experimental
}@
@[if force_experimental]@
@{
TEMPLATE(
    'msg__type_support.cpp.em',
    package_name=package_name, interface_path=interface_path,
    message=service.request_message, include_directives=include_directives,
    type_supports=type_supports,
    force_experimental=True,
    experimental_type_supports=experimental_type_supports)
}@

@{
TEMPLATE(
    'msg__type_support.cpp.em',
    package_name=package_name, interface_path=interface_path,
    message=service.response_message, include_directives=include_directives,
    type_supports=type_supports,
    force_experimental=True,
    experimental_type_supports=experimental_type_supports)
}@

@[else]@
@{
TEMPLATE(
    'msg__type_support.cpp.em',
    package_name=package_name, interface_path=interface_path,
    message=service.request_message, include_directives=include_directives,
    type_supports=type_supports)
}@

@{
TEMPLATE(
    'msg__type_support.cpp.em',
    package_name=package_name, interface_path=interface_path,
    message=service.response_message, include_directives=include_directives,
    type_supports=type_supports)
}@
@[end if]@

@[if force_experimental]@
@{
TEMPLATE(
    'msg__type_support.cpp.em',
    package_name=package_name, interface_path=interface_path,
    message=service.event_message, include_directives=include_directives,
    type_supports=type_supports,
    force_experimental=True,
    experimental_type_supports=experimental_type_supports)
}@
@[else]@
@{
TEMPLATE(
    'msg__type_support.cpp.em',
    package_name=package_name, interface_path=interface_path,
    message=service.event_message, include_directives=include_directives,
    type_supports=type_supports)
}@
@[end if]@

@{
from rosidl_generator_c import idl_structure_type_to_c_typename
from rosidl_generator_type_description import GET_DESCRIPTION_FUNC
from rosidl_generator_type_description import GET_HASH_FUNC
from rosidl_generator_type_description import GET_SOURCES_FUNC
from rosidl_parser.definition import SERVICE_EVENT_MESSAGE_SUFFIX
from rosidl_parser.definition import SERVICE_REQUEST_MESSAGE_SUFFIX
from rosidl_parser.definition import SERVICE_RESPONSE_MESSAGE_SUFFIX
from rosidl_pycommon import convert_camel_case_to_lower_case_underscore

# Determine effective parent parts for C symbol names
# Experimental services use "srv_experimental" as the parent folder
effective_parent_parts = list(interface_path.parents[0].parts)
if force_experimental:
    effective_parent_parts = [effective_parent_parts[0] + '_experimental']

# Determine C++ type namespace parts (e.g., ["srv", "experimental"] for experimental)
cpp_parent_parts = list(interface_path.parents[0].parts)
if force_experimental:
    cpp_parent_parts = cpp_parent_parts + ['experimental']

# Build include base (insert 'experimental' before 'detail' when forced)
include_parts = [package_name] + list(interface_path.parents[0].parts) + [
    'detail', convert_camel_case_to_lower_case_underscore(interface_path.stem)]
if force_experimental:
    include_parts.insert(-2, 'experimental')
include_base = '/'.join(include_parts)

# Standard parent parts for event message reference (always non-experimental)
standard_parent_parts = list(interface_path.parents[0].parts)

header_files = [
    'cstddef',
    'rosidl_runtime_c/service_type_support_struct.h',
    'rosidl_typesupport_cpp/service_type_support.hpp',
    include_base + '__struct.hpp',
]
if use_multi_typesupport:
    header_files.append('rosidl_typesupport_cpp/identifier.hpp')
if use_multi_typesupport:
    header_files += [
        'rosidl_typesupport_c/type_support_map.h',
        'rosidl_typesupport_cpp/service_type_support_dispatch.hpp',
    ]
header_files.append('rosidl_typesupport_cpp/visibility_control.h')
if use_multi_typesupport:
    header_files.append('rosidl_typesupport_interface/macros.h')
}@
@[for header_file in header_files]@
@[    if header_file in include_directives]@
// already included above
// @
@[    else]@
@{include_directives.add(header_file)}@
@[    end if]@
#include "@(header_file)"
@[end for]@

@[if use_multi_typesupport]@
@[  if force_experimental]@
@[    for ns in list(service.namespaced_type.namespaces) + ['experimental']]@

namespace @(ns)
{
@[    end for]@
@[  else]@
@[    for ns in service.namespaced_type.namespaces]@

namespace @(ns)
{
@[    end for]@
@[  end if]@

namespace rosidl_typesupport_cpp
{

typedef struct _@(service.namespaced_type.name)_type_support_ids_t
{
  const char * typesupport_identifier[@(len(effective_type_supports))];
} _@(service.namespaced_type.name)_type_support_ids_t;

static const _@(service.namespaced_type.name)_type_support_ids_t _@(service.namespaced_type.name)_service_typesupport_ids = {
  {
@# TODO(dirk-thomas) use identifier symbol again
@[for type_support in sorted(effective_type_supports)]@
    "@(type_support)",  // ::@(type_support)::typesupport_identifier,
@[end for]@
  }
};

typedef struct _@(service.namespaced_type.name)_type_support_symbol_names_t
{
  const char * symbol_name[@(len(effective_type_supports))];
} _@(service.namespaced_type.name)_type_support_symbol_names_t;
#define STRINGIFY_(s) #s
#define STRINGIFY(s) STRINGIFY_(s)

static const _@(service.namespaced_type.name)_type_support_symbol_names_t _@(service.namespaced_type.name)_service_typesupport_symbol_names = {
  {
@[for type_support in sorted(effective_type_supports)]@
    STRINGIFY(ROSIDL_TYPESUPPORT_INTERFACE__SERVICE_SYMBOL_NAME(@(type_support), @(', '.join([package_name] + effective_parent_parts)), @(service.namespaced_type.name))),
@[end for]@
  }
};

typedef struct _@(service.namespaced_type.name)_type_support_data_t
{
  void * data[@(len(effective_type_supports))];
} _@(service.namespaced_type.name)_type_support_data_t;

static _@(service.namespaced_type.name)_type_support_data_t _@(service.namespaced_type.name)_service_typesupport_data = {
  {
@[for type_support in sorted(effective_type_supports)]@
    0,  // will store the shared library later
@[end for]@
  }
};

static const type_support_map_t _@(service.namespaced_type.name)_service_typesupport_map = {
  @(len(effective_type_supports)),
  "@(package_name)",
  &_@(service.namespaced_type.name)_service_typesupport_ids.typesupport_identifier[0],
  &_@(service.namespaced_type.name)_service_typesupport_symbol_names.symbol_name[0],
  &_@(service.namespaced_type.name)_service_typesupport_data.data[0],
};

static const rosidl_service_type_support_t @(service.namespaced_type.name)_service_type_support_handle = {
  ::rosidl_typesupport_cpp::typesupport_identifier,
  reinterpret_cast<const type_support_map_t *>(&_@(service.namespaced_type.name)_service_typesupport_map),
  ::rosidl_typesupport_cpp::get_service_typesupport_handle_function,
@[if force_experimental]@
  ::rosidl_typesupport_cpp::get_message_type_support_handle<@('::'.join([package_name] + cpp_parent_parts + [service.namespaced_type.name]))@(SERVICE_REQUEST_MESSAGE_SUFFIX)>(),
  ::rosidl_typesupport_cpp::get_message_type_support_handle<@('::'.join([package_name] + cpp_parent_parts + [service.namespaced_type.name]))@(SERVICE_RESPONSE_MESSAGE_SUFFIX)>(),
  ::rosidl_typesupport_cpp::get_message_type_support_handle<@('::'.join([package_name] + cpp_parent_parts + [service.namespaced_type.name]))@(SERVICE_EVENT_MESSAGE_SUFFIX)>(),
@[else]@
  ::rosidl_typesupport_cpp::get_message_type_support_handle<@('::'.join([package_name, *interface_path.parents[0].parts, service.namespaced_type.name]))@(SERVICE_REQUEST_MESSAGE_SUFFIX)>(),
  ::rosidl_typesupport_cpp::get_message_type_support_handle<@('::'.join([package_name, *interface_path.parents[0].parts, service.namespaced_type.name]))@(SERVICE_RESPONSE_MESSAGE_SUFFIX)>(),
  ::rosidl_typesupport_cpp::get_message_type_support_handle<@('::'.join([package_name, *interface_path.parents[0].parts, service.namespaced_type.name]))@(SERVICE_EVENT_MESSAGE_SUFFIX)>(),
@[end if]@
@[if force_experimental]@
  nullptr,
  nullptr,
  nullptr,
  nullptr,
  nullptr,
@[else]@
  &::rosidl_typesupport_cpp::service_create_event_message<@('::'.join([package_name, *interface_path.parents[0].parts, service.namespaced_type.name]))>,
  &::rosidl_typesupport_cpp::service_destroy_event_message<@('::'.join([package_name, *interface_path.parents[0].parts, service.namespaced_type.name]))>,
  &@(idl_structure_type_to_c_typename(service.namespaced_type))__@(GET_HASH_FUNC),
  &@(idl_structure_type_to_c_typename(service.namespaced_type))__@(GET_DESCRIPTION_FUNC),
  &@(idl_structure_type_to_c_typename(service.namespaced_type))__@(GET_SOURCES_FUNC),
@[end if]@
};

}  // namespace rosidl_typesupport_cpp
@[  if force_experimental]@
@[    for ns in reversed(list(service.namespaced_type.namespaces) + ['experimental'])]@

}  // namespace @(ns)
@[    end for]@
@[  else]@
@[    for ns in reversed(service.namespaced_type.namespaces)]@

}  // namespace @(ns)
@[    end for]@
@[  end if]@

@[else]@
@{
if force_experimental:
    include_parts = [package_name] + list(interface_path.parents[0].parts) + [
        'experimental', 'detail', convert_camel_case_to_lower_case_underscore(interface_path.stem)]
else:
    include_parts = [package_name] + list(interface_path.parents[0].parts) + [
        'detail', convert_camel_case_to_lower_case_underscore(interface_path.stem)]
include_base = '/'.join(include_parts)
header_file = include_base + '__' + list(effective_type_supports)[0] + '.hpp'
}@
@[  if header_file in include_directives]@
// already included above
// @
@[  else]@
@{include_directives.add(header_file)}@
@[  end if]@
#include "@(header_file)"

@[end if]@
namespace rosidl_typesupport_cpp
{

template<>
ROSIDL_TYPESUPPORT_CPP_PUBLIC
const rosidl_service_type_support_t *
get_service_type_support_handle<@('::'.join([package_name] + cpp_parent_parts + [service.namespaced_type.name]))>()
{
@[if use_multi_typesupport]@
@[  if force_experimental]@
  return &::@('::'.join([package_name] + list(interface_path.parents[0].parts) + ['experimental']))::rosidl_typesupport_cpp::@(service.namespaced_type.name)_service_type_support_handle;
@[  else]@
  return &::@('::'.join([package_name] + list(interface_path.parents[0].parts)))::rosidl_typesupport_cpp::@(service.namespaced_type.name)_service_type_support_handle;
@[  end if]@
@[else]@
  return ROSIDL_TYPESUPPORT_INTERFACE__SERVICE_SYMBOL_NAME(@(list(effective_type_supports)[0]), @(', '.join([package_name] + effective_parent_parts)), @(service.namespaced_type.name))();
@[end if]@
}

}  // namespace rosidl_typesupport_cpp

#ifdef __cplusplus
extern "C"
{
#endif

ROSIDL_TYPESUPPORT_CPP_PUBLIC
const rosidl_service_type_support_t *
ROSIDL_TYPESUPPORT_INTERFACE__SERVICE_SYMBOL_NAME(rosidl_typesupport_cpp, @(', '.join([package_name] + effective_parent_parts + [service.namespaced_type.name])))() {
  return ::rosidl_typesupport_cpp::get_service_type_support_handle<@('::'.join([package_name] + cpp_parent_parts + [service.namespaced_type.name]))>();
}

#ifdef __cplusplus
}
#endif
