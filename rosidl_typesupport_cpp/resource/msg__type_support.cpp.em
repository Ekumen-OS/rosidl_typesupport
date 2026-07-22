@# Included from rosidl_typesupport_cpp/resource/idl__type_support.cpp.em
@{
from rosidl_generator_c import idl_structure_type_to_c_typename
from rosidl_generator_type_description import GET_DESCRIPTION_FUNC
from rosidl_generator_type_description import GET_HASH_FUNC
from rosidl_generator_type_description import GET_SOURCES_FUNC
from rosidl_pycommon import convert_camel_case_to_lower_case_underscore

# Get optional force_experimental flag (set by experimental wrapper templates).
# When True, always generate experimental-message code paths regardless of namespace.
try:
    force_experimental
except NameError:
    force_experimental = False

# Get optional experimental_type_supports (the subset that support experimental messages).
# When not provided, defaults to empty list (triggers standard path).
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

# Determine effective parent parts for C symbol names
# Experimental messages use "msg_experimental" as the parent folder
# to avoid breaking the 4-argument ROSIDL_TYPESUPPORT_INTERFACE__MESSAGE_SYMBOL_NAME macro
effective_parent_parts = list(interface_path.parents[0].parts)
if force_experimental:
    effective_parent_parts = [effective_parent_parts[0] + '_experimental']

# Determine C++ type namespace parts (e.g., ["msg", "experimental"] for experimental)
cpp_parent_parts = list(interface_path.parents[0].parts)
if force_experimental:
    cpp_parent_parts = cpp_parent_parts + ['experimental']

# Build include base (insert 'experimental' before 'detail' when forced)
include_parts = [package_name] + list(interface_path.parents[0].parts) + [
    'detail', convert_camel_case_to_lower_case_underscore(interface_path.stem)]
if force_experimental:
    # Insert 'experimental' before 'detail'
    include_parts.insert(-2, 'experimental')
include_base = '/'.join(include_parts)

header_files = [
    'cstddef',
    'rosidl_runtime_c/message_type_support_struct.h',
    include_base + '__functions.h',
    include_base + '__struct.hpp',
]
# Experimental struct headers may use C++ type traits in macros
# (e.g., rosidl_runtime_c/experimental/array.h uses std::is_same_v
# in its PRIMITIVE_ARRAY_DISPATCH C++ path). Include type_traits
# before any experimental headers to avoid missing include errors.
if force_experimental:
    header_files.insert(0, 'type_traits')
if use_multi_typesupport:
    header_files.append('rosidl_typesupport_cpp/identifier.hpp')
header_files.append('rosidl_typesupport_cpp/message_type_support.hpp')
if use_multi_typesupport:
    header_files += [
        'rosidl_typesupport_c/type_support_map.h',
        'rosidl_typesupport_cpp/message_type_support_dispatch.hpp',
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
@
@[if use_multi_typesupport]@
@[  if force_experimental]@
@[    for ns in list(message.structure.namespaced_type.namespaces) + ['experimental']]@

namespace @(ns)
{
@[    end for]@
@[  else]@
@[    for ns in message.structure.namespaced_type.namespaces]@

namespace @(ns)
{
@[    end for]@
@[  end if]@

namespace rosidl_typesupport_cpp
{

typedef struct _@(message.structure.namespaced_type.name)_type_support_ids_t
{
  const char * typesupport_identifier[@(len(effective_type_supports))];
} _@(message.structure.namespaced_type.name)_type_support_ids_t;

static const _@(message.structure.namespaced_type.name)_type_support_ids_t _@(message.structure.namespaced_type.name)_message_typesupport_ids = {
  {
@# TODO(dirk-thomas) use identifier symbol again
@[for type_support in sorted(effective_type_supports)]@
    "@(type_support)",  // ::@(type_support)::typesupport_identifier,
@[end for]@
  }
};

typedef struct _@(message.structure.namespaced_type.name)_type_support_symbol_names_t
{
  const char * symbol_name[@(len(effective_type_supports))];
} _@(message.structure.namespaced_type.name)_type_support_symbol_names_t;

#define STRINGIFY_(s) #s
#define STRINGIFY(s) STRINGIFY_(s)

static const _@(message.structure.namespaced_type.name)_type_support_symbol_names_t _@(message.structure.namespaced_type.name)_message_typesupport_symbol_names = {
  {
@[for type_support in sorted(effective_type_supports)]@
    STRINGIFY(ROSIDL_TYPESUPPORT_INTERFACE__MESSAGE_SYMBOL_NAME(@(type_support), @(', '.join([package_name] + effective_parent_parts)), @(message.structure.namespaced_type.name))),
@[end for]@
  }
};

typedef struct _@(message.structure.namespaced_type.name)_type_support_data_t
{
  void * data[@(len(effective_type_supports))];
} _@(message.structure.namespaced_type.name)_type_support_data_t;

static _@(message.structure.namespaced_type.name)_type_support_data_t _@(message.structure.namespaced_type.name)_message_typesupport_data = {
  {
@[for type_support in sorted(effective_type_supports)]@
    0,  // will store the shared library later
@[end for]@
  }
};

static const type_support_map_t _@(message.structure.namespaced_type.name)_message_typesupport_map = {
  @(len(effective_type_supports)),
  "@(package_name)",
  &_@(message.structure.namespaced_type.name)_message_typesupport_ids.typesupport_identifier[0],
  &_@(message.structure.namespaced_type.name)_message_typesupport_symbol_names.symbol_name[0],
  &_@(message.structure.namespaced_type.name)_message_typesupport_data.data[0],
};

@[if force_experimental]@
// Default fallbacks for experimental types that lack generated type hash/description.
extern "C" const rosidl_type_hash_t *
@(message.structure.namespaced_type.name)_default_get_type_hash(const rosidl_message_type_support_t *)
{
  static const rosidl_type_hash_t zero_hash = {0, {0}};
  return &zero_hash;
}
extern "C" const rosidl_runtime_c__type_description__TypeDescription *
@(message.structure.namespaced_type.name)_default_get_type_description(const rosidl_message_type_support_t *)
{
  return nullptr;
}
extern "C" const rosidl_runtime_c__type_description__TypeSource__Sequence *
@(message.structure.namespaced_type.name)_default_get_type_description_sources(const rosidl_message_type_support_t *)
{
  return nullptr;
}
@[end if]@

static const rosidl_message_type_support_t @(message.structure.namespaced_type.name)_message_type_support_handle = {
  ::rosidl_typesupport_cpp::typesupport_identifier,
  reinterpret_cast<const type_support_map_t *>(&_@(message.structure.namespaced_type.name)_message_typesupport_map),
  ::rosidl_typesupport_cpp::get_message_typesupport_handle_function,
@[if force_experimental]@
  &@(message.structure.namespaced_type.name)_default_get_type_hash,
  &@(message.structure.namespaced_type.name)_default_get_type_description,
  &@(message.structure.namespaced_type.name)_default_get_type_description_sources,
@[else]@
  &@(idl_structure_type_to_c_typename(message.structure.namespaced_type))__@(GET_HASH_FUNC),
  &@(idl_structure_type_to_c_typename(message.structure.namespaced_type))__@(GET_DESCRIPTION_FUNC),
  &@(idl_structure_type_to_c_typename(message.structure.namespaced_type))__@(GET_SOURCES_FUNC),
@[end if]@
};

}  // namespace rosidl_typesupport_cpp
@[  if force_experimental]@
@[    for ns in reversed(list(message.structure.namespaced_type.namespaces) + ['experimental'])]@

}  // namespace @(ns)
@[    end for]@
@[  else]@
@[    for ns in reversed(message.structure.namespaced_type.namespaces)]@

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
const rosidl_message_type_support_t *
get_message_type_support_handle<@('::'.join([package_name] + cpp_parent_parts))::@(message.structure.namespaced_type.name)>()
{
@[if use_multi_typesupport]@
@[  if force_experimental]@
  return &::@('::'.join([package_name] + list(interface_path.parents[0].parts) + ['experimental']))::rosidl_typesupport_cpp::@(message.structure.namespaced_type.name)_message_type_support_handle;
@[  else]@
  return &::@('::'.join([package_name] + list(interface_path.parents[0].parts)))::rosidl_typesupport_cpp::@(message.structure.namespaced_type.name)_message_type_support_handle;
@[  end if]@
@[else]@
  return ROSIDL_TYPESUPPORT_INTERFACE__MESSAGE_SYMBOL_NAME(@(list(effective_type_supports)[0]), @(', '.join([package_name] + effective_parent_parts)), @(message.structure.namespaced_type.name))();
@[end if]@
}

#ifdef __cplusplus
extern "C"
{
#endif

ROSIDL_TYPESUPPORT_CPP_PUBLIC
const rosidl_message_type_support_t *
ROSIDL_TYPESUPPORT_INTERFACE__MESSAGE_SYMBOL_NAME(rosidl_typesupport_cpp, @(', '.join([package_name] + effective_parent_parts)), @(message.structure.namespaced_type.name))() {
  return get_message_type_support_handle<@('::'.join([package_name] + cpp_parent_parts))::@(message.structure.namespaced_type.name)>();
}

#ifdef __cplusplus
}
#endif
}  // namespace rosidl_typesupport_cpp
