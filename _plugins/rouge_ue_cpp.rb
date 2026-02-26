# frozen_string_literal: true

# Custom Rouge lexer for Unreal Engine C++
# Extends the built-in C++ lexer with UE-specific token recognition.
#
# Usage in markdown:
#   ```ue_cpp
#   UCLASS()
#   class AMyActor : public AActor { ... };
#   ```
#
# Token mapping:
#   Name::Decorator  (.nd) → UE core macros         (UCLASS, UPROPERTY, ...)
#   Name::Builtin    (.nb) → UE utility macros       (UE_LOG, TEXT, ...)
#   Name::Class      (.nc) → UE types                (FString, TArray, AActor, ...)
#   Name::Attribute  (.na) → UE specifiers           (BlueprintReadWrite, ...)
#   Name::Function   (.nf) → function/method calls   (AddPass, GetWorld, ...)

require "rouge"
require "set"

module Rouge
  module Lexers
    class UECpp < Cpp
      title "UE C++"
      desc  "Unreal Engine C++ (extends Rouge C++ lexer with UE token recognition)"

      tag     "ue_cpp"
      aliases "uecpp", "cpp", "c++"

      # -----------------------------------------------------------------------
      # UE Core Macros (.nd → purple #bd63c5)
      # -----------------------------------------------------------------------
      UE_CORE_MACROS = %w[
        UCLASS
        USTRUCT
        UENUM
        UINTERFACE
        UDELEGATE
        UPROPERTY
        UFUNCTION
        UMETA
        UPARAM
        RIGVM_METHOD

        GENERATED_BODY
        GENERATED_UCLASS_BODY
        GENERATED_USTRUCT_BODY
        GENERATED_UINTERFACE_BODY
        GENERATED_IINTERFACE_BODY

        DECLARE_DYNAMIC_MULTICAST_DELEGATE
        DECLARE_DYNAMIC_MULTICAST_DELEGATE_OneParam
        DECLARE_DYNAMIC_MULTICAST_DELEGATE_TwoParams
        DECLARE_DYNAMIC_MULTICAST_DELEGATE_ThreeParams
        DECLARE_DYNAMIC_MULTICAST_DELEGATE_FourParams
        DECLARE_DYNAMIC_MULTICAST_DELEGATE_FiveParams
        DECLARE_DYNAMIC_MULTICAST_DELEGATE_SixParams
        DECLARE_DYNAMIC_MULTICAST_DELEGATE_SevenParams
        DECLARE_DYNAMIC_MULTICAST_DELEGATE_EightParams
        DECLARE_DYNAMIC_MULTICAST_DELEGATE_NineParams
        DECLARE_DYNAMIC_MULTICAST_SPARSE_DELEGATE_OneParam
        DECLARE_DYNAMIC_DELEGATE
        DECLARE_DYNAMIC_DELEGATE_RetVal
        DECLARE_DYNAMIC_DELEGATE_OneParam
        DECLARE_DYNAMIC_DELEGATE_TwoParams
        DECLARE_DYNAMIC_DELEGATE_ThreeParams
        DECLARE_DYNAMIC_DELEGATE_FourParams
        DECLARE_MULTICAST_DELEGATE
        DECLARE_MULTICAST_DELEGATE_OneParam
        DECLARE_MULTICAST_DELEGATE_TwoParams
        DECLARE_MULTICAST_DELEGATE_ThreeParams
        DECLARE_MULTICAST_DELEGATE_FourParams
        DECLARE_DELEGATE
        DECLARE_DELEGATE_OneParam
        DECLARE_DELEGATE_TwoParams
        DECLARE_DELEGATE_ThreeParams
        DECLARE_DELEGATE_FourParams
        DECLARE_DELEGATE_RetVal
        DECLARE_DELEGATE_RetVal_OneParam
        DECLARE_DELEGATE_RetVal_TwoParams
        DECLARE_EVENT
        DECLARE_EVENT_OneParam
        DECLARE_EVENT_TwoParams
        DECLARE_EVENT_ThreeParams
        DECLARE_EVENT_FourParams

        DECLARE_LOG_CATEGORY_EXTERN
        DECLARE_LOG_CATEGORY_CLASS
        DEFINE_LOG_CATEGORY
        DEFINE_LOG_CATEGORY_STATIC

        IMPLEMENT_PRIMARY_GAME_MODULE
        IMPLEMENT_GAME_MODULE
        IMPLEMENT_MODULE

        UE_DECLARE_GAMEPLAY_TAG_EXTERN
        UE_DEFINE_GAMEPLAY_TAG
        UE_DEFINE_GAMEPLAY_TAG_COMMENT

        DECLARE_GLOBAL_SHADER
        IMPLEMENT_GLOBAL_SHADER
        IMPLEMENT_GLOBAL_SHADER_PUBLIC_INTERFACE
        IMPLEMENT_MATERIAL_SHADER_TYPE
        IMPLEMENT_SHADER_TYPE
        IMPLEMENT_SHADER_TYPE2
        BEGIN_SHADER_PARAMETER_STRUCT
        END_SHADER_PARAMETER_STRUCT
        BEGIN_GLOBAL_SHADER_PARAMETER_STRUCT
        END_GLOBAL_SHADER_PARAMETER_STRUCT
        IMPLEMENT_GLOBAL_SHADER_PARAMETER_STRUCT
        BEGIN_UNIFORM_BUFFER_STRUCT
        END_UNIFORM_BUFFER_STRUCT
        IMPLEMENT_UNIFORM_BUFFER_STRUCT
        SHADER_PARAMETER
        SHADER_PARAMETER_ARRAY
        SHADER_PARAMETER_STRUCT
        SHADER_PARAMETER_STRUCT_REF
        SHADER_PARAMETER_STRUCT_ARRAY
        SHADER_PARAMETER_STRUCT_INCLUDE
        SHADER_PARAMETER_TEXTURE
        SHADER_PARAMETER_SAMPLER
        SHADER_PARAMETER_SRV
        SHADER_PARAMETER_UAV
        SHADER_PARAMETER_RDG_TEXTURE
        SHADER_PARAMETER_RDG_TEXTURE_SRV
        SHADER_PARAMETER_RDG_TEXTURE_UAV
        SHADER_PARAMETER_RDG_TEXTURE_ARRAY
        SHADER_PARAMETER_RDG_BUFFER
        SHADER_PARAMETER_RDG_BUFFER_SRV
        SHADER_PARAMETER_RDG_BUFFER_UAV
        SHADER_PARAMETER_RDG_UNIFORM_BUFFER
        SHADER_PARAMETER_UNIFORM_BUFFER
        SHADER_USE_PARAMETER_STRUCT
        SHADER_PERMUTATION_BOOL
        SHADER_PERMUTATION_INT
        SHADER_PERMUTATION_RANGE_INT
        SHADER_PERMUTATION_ENUM_CLASS
        SHADER_PERMUTATION_SPARSE_INT

        RDG_EVENT_NAME
        RDG_EVENT_SCOPE
        RDG_EVENT_SCOPE_CONDITIONAL
        RDG_GPU_STAT_SCOPE
        RDG_GPU_STAT_SCOPE_VERBOSE
        RDG_GPU_MASK_SCOPE
        RDG_DEFINE_GPU_STAT
        RDG_DECLARE_GPU_STAT
        RDG_DECLARE_GPU_STAT_GLOBAL

        SCOPED_DRAW_EVENT
        SCOPED_DRAW_EVENTF
        SCOPED_CONDITIONAL_DRAW_EVENT
        SCOPED_GPU_STAT
        GPU_DEBUG_SCOPE

        RPC_VALIDATE
        DEPRECATED
        UE_DEPRECATED
        MARK_PROPERTY_DIRTY_FROM_NAME

        UMG_API
        ENGINE_API
        CORE_API
        COREUOBJECT_API
        RENDERER_API
        RENDERCORE_API
        RHI_API
        SLATE_API
        SLATECORE_API
        INPUTCORE_API
        GAMEPLAYABILITIES_API
        AIMODULE_API
        NAVIGATIONSYSTEM_API
        UNREALED_API
        BLUTILITY_API
        UMG_API
      ].freeze

      # -----------------------------------------------------------------------
      # UE Utility Macros (.nb → teal #4ec9b0)
      # -----------------------------------------------------------------------
      UE_UTIL_MACROS = %w[
        UE_LOG
        UE_LOGFMT
        UE_CLOG
        UE_VLOG
        UE_VLOG_SEGMENT
        UE_VLOG_LOCATION
        UE_VLOG_BOX
        UE_VLOG_OBOX
        UE_VLOG_CONE
        UE_VLOG_CYLINDER
        UE_VLOG_CAPSULE

        TEXT
        LOCTEXT
        LOCTEXT_NAMESPACE
        NSLOCTEXT
        INVTEXT
        TEXTVIEW
        LOCGEN_NAME_OR_STRING

        check
        checkf
        checkCode
        checkNoEntry
        checkNoReentry
        checkNoRecursion
        checkSlow
        checkfSlow
        verify
        verifyf
        ensure
        ensureMsgf
        ensureAlways
        ensureAlwaysMsgf
        unimplemented

        LIKELY
        UNLIKELY
        PLATFORM_LIKELY
        PLATFORM_UNLIKELY

        FORCEINLINE
        FORCEINLINE_DEBUGGABLE
        FORCENOINLINE
        PURE_VIRTUAL
        ABSTRACT

        PRAGMA_DISABLE_OPTIMIZATION
        PRAGMA_ENABLE_OPTIMIZATION
        PRAGMA_DISABLE_OPTIMIZATION_ACTUAL
        PRAGMA_ENABLE_OPTIMIZATION_ACTUAL
        PRAGMA_PUSH_PLATFORM_DEFAULT_PACKING
        PRAGMA_POP_PLATFORM_DEFAULT_PACKING
        PRAGMA_DISABLE_UNSAFE_TYPECAST_WARNINGS
        PRAGMA_RESTORE_UNSAFE_TYPECAST_WARNINGS

        WITH_EDITOR
        WITH_EDITORONLY_DATA
        WITH_SERVER_CODE
        WITH_CLIENT_CODE
        WITH_DEV_AUTOMATION_TESTS
        WITH_PERF_AUTOMATION_TESTS

        UE_BUILD_DEBUG
        UE_BUILD_DEVELOPMENT
        UE_BUILD_TEST
        UE_BUILD_SHIPPING

        PLATFORM_WINDOWS
        PLATFORM_MAC
        PLATFORM_LINUX
        PLATFORM_ANDROID
        PLATFORM_IOS
        PLATFORM_TVOS
        PLATFORM_HOLOLENS
        PLATFORM_DESKTOP
        PLATFORM_MOBILE
        PLATFORM_CONSOLE
        PLATFORM_64BITS
        PLATFORM_LITTLE_ENDIAN

        GET_MEMBER_NAME_CHECKED
        GET_MEMBER_NAME_STRING_CHECKED
        GET_FUNCTION_NAME_CHECKED
        GET_FUNCTION_NAME_STRING_CHECKED
        GET_CLASS_NAME_CHECKED

        INDEX_NONE
        MAX_int8
        MIN_int8
        MAX_uint8
        MAX_int16
        MIN_int16
        MAX_uint16
        MAX_int32
        MIN_int32
        MAX_uint32
        MAX_int64
        MIN_int64
        MAX_uint64
        MAX_FLT
        MIN_FLT
        MAX_dbl
        KINDA_SMALL_NUMBER
        SMALL_NUMBER
        BIG_NUMBER
        EUCLID
        PI
        INV_PI
        HALF_PI
        TWO_PI
        GOLDEN_RATIO
        FLOAT_NON_FRACTIONAL
        DELTA
        THRESH_POINT_ON_PLANE
        THRESH_POINT_ON_SIDE
        THRESH_POINTS_ARE_SAME
        THRESH_POINTS_ARE_NEAR
        THRESH_NORMALS_ARE_SAME
        THRESH_VECTORS_ARE_NEAR
        THRESH_SPLIT_POLY_WITH_PLANE
        THRESH_SPLIT_POLY_PRECISELY
        THRESH_ZERO_NORM_SQUARED
        THRESH_NORMALS_ARE_PARALLEL
        THRESH_NORMALS_ARE_ORTHOGONAL

        INVALID_HANDLE_VALUE
        ARRAY_COUNT
        UE_ARRAY_COUNT
        STRUCT_OFFSET
        PROPERTY_OFFSET

        IN
        OUT
        TCHAR_TO_UTF8
        UTF8_TO_TCHAR
        TCHAR_TO_ANSI
        ANSI_TO_TCHAR
        TCHAR_TO_UTF16
        UTF16_TO_TCHAR
        StringCast

        DECLARE_INTERFACE
        DECLARE_INTERFACE_FUNCTION
        DECLARE_STATS_GROUP
        DECLARE_STATS_GROUP_VERBOSE
        DECLARE_CYCLE_STAT
        DECLARE_CYCLE_STAT_EXTERN
        DECLARE_FLOAT_COUNTER_STAT
        DECLARE_DWORD_COUNTER_STAT
        DECLARE_FLOAT_ACCUMULATOR_STAT
        DECLARE_DWORD_ACCUMULATOR_STAT
        DECLARE_MEMORY_STAT
        DECLARE_MEMORY_STAT_EXTERN
        DEFINE_STAT
        SCOPE_CYCLE_COUNTER
        SCOPE_CYCLE_COUNTER_VERBOSE
        QUICK_SCOPE_CYCLE_COUNTER
        SCOPED_NAMED_EVENT
        SCOPED_NAMED_EVENT_F
        SCOPED_NAMED_EVENT_FSTRING
        TRACE_CPUPROFILER_EVENT_SCOPE
        TRACE_CPUPROFILER_EVENT_SCOPE_STR
        TRACE_CPUPROFILER_EVENT_SCOPE_TEXT
        CSV_SCOPED_TIMING_STAT
        CSV_CUSTOM_STAT
        CSV_EVENT
      ].freeze

      # -----------------------------------------------------------------------
      # UE Enum-like Specifiers (.no → amber #b9771e)
      # These are actual enum values passed inside UPROPERTY/UFUNCTION macros.
      # -----------------------------------------------------------------------
      UE_ENUM_SPECIFIERS = %w[
        BlueprintReadWrite
        BlueprintReadOnly
        BlueprintGetter
        BlueprintSetter
        BlueprintAssignable
        BlueprintCallable
        BlueprintPure
        BlueprintEvent
        BlueprintNativeEvent
        BlueprintImplementableEvent
        BlueprintCosmetic
        BlueprintAuthorityOnly
        BlueprintType
        Blueprintable
        NotBlueprintType
        NotBlueprintable

        EditAnywhere
        EditDefaultsOnly
        EditInstanceOnly
        EditFixedSize
        EditInlineNew
        NotEditInlineNew
        VisibleAnywhere
        VisibleDefaultsOnly
        VisibleInstanceOnly
        AdvancedDisplay
        AllowPrivateAccess
        AllowAbstract
        NoClear
        NoResetToDefault
        ShowInnerProperties

        Replicated
        ReplicatedUsing
        NotReplicated
        RepRetry

        SaveGame
        Config
        GlobalConfig
        Localized
        Transient
        DuplicateTransient
        NonTransactional
        NonPIEDuplicateTransient
        SkipSerialization
        TextExportTransient
        NoDestroySubobject
        PersistentInstance
        Export
        Instanced
        AssetRegistrySearchable
        SimpleDisplay
        FullyExpand

        Exec
        Server
        Client
        NetMulticast
        Reliable
        Unreliable
        WithValidation
        ServiceRequest
        ServiceResponse

        Abstract
        Deprecated
        HideDropdown
        HideFunctions
        MinimalAPI
        Within
        ClassGroup
        ShowCategories
        HideCategories
        AutoCollapseCategories
        AutoExpandCategories
        ComponentWrapperClass
        ConversionRoot
        CustomConstructor
        DefaultToInstanced
        DontAutoCollapseCategories
        DontCollapseCategories
        Intrinsic
        NoExport
        PerObjectConfig
        Placeable
        NotPlaceable
        Const
        CustomReplicationFunction
      ].freeze

      # -----------------------------------------------------------------------
      # UE Key Specifiers (.nn → green #b8d7a3)
      # These are key=value pairs inside macros (Category="...", meta=(...))
      # -----------------------------------------------------------------------
      UE_KEY_SPECIFIERS = %w[
        Category
        Categories
        meta
        DisplayName
        DisplayPriority
        ToolTip
        ShortTooltip
        Keywords
        CompactNodeTitle
        MapKeyParam
        MapValueParam
        ArrayParm
        ArrayTypeDependentParams
        AutoCreateRefTerm
        CommutativeAssociativeBinaryOperator
        CppFromBpEvent
        DeterminesOutputType
        DynamicOutputParam
        HidePin
        HideSelfPin
        InternalUseParam
        Latent
        LatentInfo
        MaterialParameterCollectionFunction
        NativeBreakFunc
        NativeMakeFunc
        NotBlueprintThreadSafe
        UnsafeDuringActorConstruction
        WorldContext
        DefaultToSelf
        CustomThunk
        CallInEditor
        DataTablePin
        ExpandEnumAsExecs
        ExpandBoolAsExecs
        DefaultValue
        ReturnDisplayName
        UIMin
        UIMax
        ClampMin
        ClampMax
        Units
        ForceUnits
        MakeEditWidget
        MakeStructureDefaultValue
        ShowOnlyInnerProperties
        TitleProperty
        EditCondition
        EditConditionHides
        InlineEditConditionToggle
        PinHiddenByDefault
        PinShownByDefault
      ].freeze

      # -----------------------------------------------------------------------
      # UE Property / Function Specifiers (.na → sky blue #9cdcfe)
      # Remaining specifiers not covered above.
      # -----------------------------------------------------------------------
      UE_SPECIFIERS = %w[
        NeedsLatentFixup

        SparseClassDataType
        BlueprintSpawnableComponent
        ClassSubclassOf
        ExactClass
        SubclassOf
        MetaClass
      ].freeze

      # -----------------------------------------------------------------------
      # C++ keywords to exclude from function call detection.
      # -----------------------------------------------------------------------
      CPP_KEYWORDS = %w[
        if else for while do switch case break continue return
        goto try catch throw new delete sizeof typeof decltype
        namespace using template typename class struct enum union
        operator static_cast dynamic_cast reinterpret_cast const_cast
        alignof alignas noexcept static_assert
      ].freeze

      # -----------------------------------------------------------------------
      # STL types list for std:: namespace recognition.
      # -----------------------------------------------------------------------
      STD_TYPES = %w[
        string wstring u8string u16string u32string string_view wstring_view
        vector array deque list forward_list
        map unordered_map multimap unordered_multimap
        set unordered_set multiset unordered_multiset
        stack queue priority_queue
        pair tuple optional variant any
        shared_ptr unique_ptr weak_ptr enable_shared_from_this
        function bind
        thread mutex recursive_mutex timed_mutex
        condition_variable condition_variable_any
        lock_guard unique_lock scoped_lock shared_lock
        atomic atomic_bool atomic_int atomic_flag
        future promise packaged_task async
        exception runtime_error logic_error
        out_of_range invalid_argument overflow_error underflow_error
        domain_error range_error length_error bad_alloc bad_cast bad_typeid
        initializer_list type_info
        bitset
        chrono filesystem
        regex smatch cmatch wsmatch wcmatch
        istringstream ostringstream stringstream
        ifstream ofstream fstream
        istream ostream iostream
        cin cout cerr clog
        size_t ptrdiff_t nullptr_t
        int8_t int16_t int32_t int64_t
        uint8_t uint16_t uint32_t uint64_t
        intptr_t uintptr_t intmax_t uintmax_t
        remove_reference remove_const remove_volatile remove_cv
        remove_pointer remove_extent remove_all_extents
        add_const add_volatile add_cv add_pointer add_lvalue_reference add_rvalue_reference
        make_signed make_unsigned
        decay enable_if conditional
        is_same is_base_of is_convertible is_constructible is_assignable
        is_void is_null_pointer is_integral is_floating_point is_array is_pointer
        is_lvalue_reference is_rvalue_reference is_member_pointer is_enum is_union is_class
        is_function is_trivial is_standard_layout is_pod is_abstract is_polymorphic is_final
        is_const is_volatile is_signed is_unsigned is_arithmetic is_scalar is_compound
        is_object is_reference is_member_function_pointer is_member_object_pointer
        is_default_constructible is_copy_constructible is_move_constructible
        is_copy_assignable is_move_assignable is_destructible
        is_trivially_constructible is_trivially_copyable
        underlying_type result_of invoke_result
        alignment_of rank extent
        integral_constant true_type false_type
        type_identity void_t
        conjunction disjunction negation
        forward_iterator_tag bidirectional_iterator_tag random_access_iterator_tag
        input_iterator_tag output_iterator_tag
        iterator_traits
        allocator allocator_traits
        char_traits
        numeric_limits
        ratio ratio_add ratio_subtract ratio_multiply ratio_divide
        complex valarray
        reference_wrapper
      ].freeze

      # UE primitive/alias types → Name::Class (gold)
      UE_PRIMITIVE_TYPES = %w[
        int8 int16 int32 int64
        uint8 uint16 uint32 uint64
        float32 float64
        TCHAR WIDECHAR ANSICHAR UTF8CHAR CHAR8 CHAR16 CHAR32
        SIZE_T SSIZE_T PTRINT UPTRINT
        BOOL UBOOL
        TYPE_OF_NULL
      ].freeze

      # STL objects (stream variables): standalone cout, cin, etc. → .vi
      STL_OBJECTS = Set.new(%w[
        cout cerr clog cin wcout wcin wcerr wclog
      ]).freeze

      # STL functions: standalone endl, forward, move, etc. → .nf
      STL_FUNCTIONS = Set.new(%w[
        endl ends flush
        forward move move_if_noexcept
        swap exchange
        make_pair make_tuple make_optional make_unique make_shared
        make_reverse_iterator make_move_iterator
        get holds_alternative visit
        static_pointer_cast dynamic_pointer_cast const_pointer_cast
        begin end rbegin rend cbegin cend crbegin crend
        find find_if find_if_not find_end find_first_of
        count count_if
        sort stable_sort partial_sort nth_element
        reverse reverse_copy rotate rotate_copy
        copy copy_if copy_n copy_backward
        fill fill_n generate generate_n
        transform
        remove remove_if remove_copy remove_copy_if
        replace replace_if replace_copy replace_copy_if
        unique unique_copy
        merge inplace_merge
        min max minmax min_element max_element minmax_element clamp
        accumulate reduce inner_product partial_sum adjacent_difference iota
        all_of any_of none_of
        for_each for_each_n
        equal mismatch is_permutation
        lower_bound upper_bound equal_range binary_search
        push_heap pop_heap make_heap sort_heap
        next_permutation prev_permutation
        advance next prev distance
        to_string to_wstring stoi stol stoll stoul stoull stof stod stold
        bind ref cref invoke apply
        async
        format print println
        hash
      ]).freeze

      STD_TYPES_SET  = Set.new(STD_TYPES).freeze
      STD_TYPES_RE    = /\Astd::(?:#{STD_TYPES.join('|')})\z/
      STL_OBJECTS_RE  = /\A(?:#{STL_OBJECTS.to_a.join('|')})\z/
      STL_FUNCS_RE    = /\A(?:#{STL_FUNCTIONS.to_a.join('|')})\z/
      UE_CORE_RE      = /\A(?:#{UE_CORE_MACROS.join('|')})\z/
      UE_UTIL_RE      = /\A(?:#{UE_UTIL_MACROS.join('|')})\z/
      UE_ENUM_SPEC_RE = /\A(?:#{UE_ENUM_SPECIFIERS.join('|')})\z/
      UE_KEY_SPEC_RE  = /\A(?:#{UE_KEY_SPECIFIERS.join('|')})\z/
      UE_SPEC_RE      = /\A(?:#{UE_SPECIFIERS.join('|')})\z/
      UE_TYPE_RE      = /\A[FUATEISN][A-Z][A-Za-z0-9_]+\z/
      UE_LOG_RE       = /\ALog[A-Z][A-Za-z0-9]+\z/
      UE_PRIM_RE      = /\A(?:#{UE_PRIMITIVE_TYPES.join('|')})\z/
      CPP_KEYWORD_RE  = /\A(?:#{CPP_KEYWORDS.join('|')})\z/

      # All C++ keywords that should always be Keyword token even if lexer
      # mis-classifies them as Name due to state machine confusion.
      ALL_CPP_KEYWORDS = Set.new(%w[
        if else for while do switch case break continue return goto
        throw try catch default
        namespace using template typename class struct enum union
        virtual const static inline explicit operator new delete sizeof
        typeof decltype alignof alignas noexcept static_assert
        override final mutable volatile constexpr consteval constinit
        const_cast static_cast dynamic_cast reinterpret_cast
        auto register extern typedef friend
        private public protected
        true false nullptr NULL
        co_await co_return co_yield
        import module requires concept
      ]).freeze

      # Token type aliases for readability
      T_NAME     = Rouge::Token::Tokens::Name
      T_NAME_O   = Rouge::Token::Tokens::Name::Other
      T_NAME_C   = Rouge::Token::Tokens::Name::Class
      T_NAME_NS  = Rouge::Token::Tokens::Name::Namespace
      T_NAME_F   = Rouge::Token::Tokens::Name::Function
      T_NAME_D   = Rouge::Token::Tokens::Name::Decorator
      T_NAME_B   = Rouge::Token::Tokens::Name::Builtin
      T_NAME_A   = Rouge::Token::Tokens::Name::Attribute
      T_NAME_VI  = Rouge::Token::Tokens::Name::Variable::Instance
      T_NAME_VG  = Rouge::Token::Tokens::Name::Variable::Global
      T_NAME_NO  = Rouge::Token::Tokens::Name::Constant
      T_OP       = Rouge::Token::Tokens::Operator
      T_PUNC     = Rouge::Token::Tokens::Punctuation
      T_TEXT     = Rouge::Token::Tokens::Text
      T_KW       = Rouge::Token::Tokens::Keyword
      T_KW_DECL  = Rouge::Token::Tokens::Keyword::Declaration
      T_KW_TYPE  = Rouge::Token::Tokens::Keyword::Type

      CONTROL_KEYWORDS = Set.new(%w[
        if else for while do switch break continue return goto
        throw try catch case default
      ]).freeze

      NAME_TOKENS = [T_NAME, T_NAME_O, T_NAME_C, T_NAME_NS].freeze

      # -----------------------------------------------------------------------
      # Override lex to post-process every token regardless of state.
      # stream_tokens output is overridden by Rouge's internal coalescing,
      # so we intercept at the lex level instead.
      # -----------------------------------------------------------------------
      def lex(code, opts = {})
        return enum_for(:lex, code, opts) unless block_given?
        tokens = []
        super(code, opts) { |t, v| tokens << [t, v] }
        post_process_tokens(tokens) { |t, v| yield t, v }
      end

      def post_process_tokens(tokens, &block)
        # 1st pass: collect template parameter names, locally declared type names,
        # and locally declared variable names.
        # template<typename T, class U> → T, U (template_params)
        # class Foo / struct Foo        → Foo  (local_types)
        # using MyType = ...            → MyType (local_types)
        # Foo foo; / float x =          → foo, x (local_vars)
        template_params = Set.new
        local_types     = Set.new
        local_vars      = Set.new

        is_type_token = ->(tok, val) {
          tok == T_KW_TYPE ||
          (NAME_TOKENS.include?(tok) && (
            local_types.include?(val)     ||
            template_params.include?(val) ||
            STD_TYPES_SET.include?(val)   ||
            UE_TYPE_RE.match?(val)        ||
            UE_PRIM_RE.match?(val)
          ))
        }

        tokens.each_with_index do |(tok, val), idx|
          # Template parameters
          if val == 'typename' || (val == 'class' && tok == T_KW)
            j = idx + 1
            j += 1 while j < tokens.size && tokens[j][0] == T_TEXT
            if j < tokens.size && NAME_TOKENS.include?(tokens[j][0])
              name = tokens[j][1]
              # Skip if followed by :: (it's a type, not a template param)
              k = j + 1
              k += 1 while k < tokens.size && tokens[k][0] == T_TEXT
              if !(k < tokens.size && tokens[k][0] == T_OP && tokens[k][1] == '::')
                template_params.add(name)
              end
            end
          end

          # class Foo / struct Foo / union Foo
          if tok == T_KW && %w[class struct union].include?(val)
            j = idx + 1
            j += 1 while j < tokens.size && tokens[j][0] == T_TEXT
            if j < tokens.size && NAME_TOKENS.include?(tokens[j][0])
              local_types.add(tokens[j][1])
            end
          end

          # using MyType = ...
          if tok == T_KW && val == 'using'
            j = idx + 1
            j += 1 while j < tokens.size && tokens[j][0] == T_TEXT
            next unless j < tokens.size && NAME_TOKENS.include?(tokens[j][0])
            name = tokens[j][1]
            k = j + 1
            k += 1 while k < tokens.size && tokens[k][0] == T_TEXT
            if k < tokens.size && tokens[k][0] == T_OP && tokens[k][1] == '='
              local_types.add(name)
            end
          end

          # Variable declarations: TypeName [*/&]* varName
          # e.g. Foo foo;  float x = 0;  TArray<T>* ptr
          if is_type_token.call(tok, val)
            j = idx + 1
            j += 1 while j < tokens.size && tokens[j][0] == T_TEXT
            # Skip pointer/ref operators
            while j < tokens.size && tokens[j][0] == T_OP &&
                  (tokens[j][1] == '*' || tokens[j][1] == '&' || tokens[j][1] == '&&' ||
                   tokens[j][1].end_with?('>'))
              j += 1
              j += 1 while j < tokens.size && tokens[j][0] == T_TEXT
            end
            if j < tokens.size && NAME_TOKENS.include?(tokens[j][0]) &&
               !local_types.include?(tokens[j][1]) &&
               !UE_TYPE_RE.match?(tokens[j][1]) &&
               !UE_PRIM_RE.match?(tokens[j][1])
              local_vars.add(tokens[j][1])
            end
          end
        end

        i = 0
        last_emitted_token = nil
        last_emitted_value = nil
        ue_macro_depth = 0   # > 0 means we're inside a UE macro call e.g. UPROPERTY(...)
        punc_depth      = 0  # tracks nested () inside UE macro
        while i < tokens.size
          token, value = tokens[i]

          # ------------------------------------------------------------------
          # Global keyword restoration — must happen BEFORE any Name checks.
          # Rouge mis-classifies keywords as Name when the lexer state is
          # confused by unusual token sequences (e.g. Foo&&&).
          # ------------------------------------------------------------------
          # Track UE macro call depth (use value-based check, not token type,
          # because post-processing hasn't run yet at this point)
          if NAME_TOKENS.include?(token) && UE_CORE_RE.match?(value)
            ue_macro_depth = 1 if ue_macro_depth == 0
          end
          if token == T_PUNC && ue_macro_depth > 0
            value.each_char do |ch|
              if ch == '('
                punc_depth += 1
              elsif ch == ')'
                punc_depth -= 1
                if punc_depth <= 0
                  ue_macro_depth = 0
                  punc_depth = 0
                  break
                end
              end
            end
          end

          if ALL_CPP_KEYWORDS.include?(value)
            t = CONTROL_KEYWORDS.include?(value) ? T_KW_DECL : T_KW
            block.call(t, value)
            last_emitted_token = t
            last_emitted_value = value
            i += 1
            next
          end

          if NAME_TOKENS.include?(token)

            # ------------------------------------------------------------------
            # Namespace chain: ns1::ns2::...::final
            # Handles both single (std::vector) and nested (std::chrono::duration)
            # Also handles Name::Class tokens like T::value_type (issue 1)
            # ------------------------------------------------------------------
            if i + 2 < tokens.size &&
               tokens[i + 1][0] == T_OP &&
               tokens[i + 1][1] == '::' &&
               NAME_TOKENS.include?(tokens[i + 2][0])

              # Collect full chain: [name, ::, name, ::, ..., name]
              chain_names = [value]
              j = i + 1
              while j + 1 < tokens.size &&
                    tokens[j][0] == T_OP && tokens[j][1] == '::' &&
                    NAME_TOKENS.include?(tokens[j + 1][0])
                chain_names << tokens[j + 1][1]
                j += 2
              end
              consumed = j  # index after last name token

              # Peek at what follows the final name
              next_tok  = tokens[consumed]
              is_call   = next_tok && next_tok[0] == T_PUNC && next_tok[1].start_with?('(')
              is_tmpl   = next_tok && next_tok[0] == T_OP   && next_tok[1] == '<'

              # Emit all but last as Namespace, last as Class or Function
              ns_prefix = chain_names[0..-2].join('::')
              final     = chain_names.last
              full      = "#{ns_prefix}::#{final}"

              # Emit namespace segments
              chain_names[0..-2].each_with_index do |seg, idx|
                block.call(T_NAME_NS, seg)
                block.call(T_OP, '::')
              end

              # Emit final name
              # UE enum convention: prefix starts with 'E' → member is a constant
              prefix_is_enum = chain_names[0..-2].last&.match?(/\A[E][A-Z][A-Za-z0-9_]+\z/)

              final_token = if prefix_is_enum
                               T_NAME_NO
                             elsif ns_prefix == 'std' && STL_OBJECTS.include?(final)
                               # std::cout, std::cin, etc. → global variable (no bold)
                               T_NAME_VG
                             elsif ns_prefix == 'std' && (STL_FUNCTIONS.include?(final) || is_call || is_tmpl)
                               # std::endl, std::forward<T>(), etc. → function
                               T_NAME_F
                             elsif STD_TYPES_RE.match?(full)
                               T_NAME_C
                             elsif is_call || is_tmpl
                               T_NAME_F
                             else
                               T_NAME_C
                             end
              block.call(final_token, final)
              last_emitted_token = final_token
              last_emitted_value = final
              i = consumed
              next
            end

            # ------------------------------------------------------------------
            # Member access via -> or .
            # ------------------------------------------------------------------
            prev_idx = i - 1
            prev_idx -= 1 while prev_idx >= 0 && tokens[prev_idx][0] == T_TEXT
            is_member_access = prev_idx >= 0 &&
                               ((tokens[prev_idx][0] == T_OP  && tokens[prev_idx][1] == '->') ||
                                (tokens[prev_idx][0] == T_PUNC && tokens[prev_idx][1] == '.'))

            # ------------------------------------------------------------------
            # Single token reclassification
            # ------------------------------------------------------------------
            next_i = i + 1
            next_i += 1 while next_i < tokens.size && tokens[next_i][0] == T_TEXT
            is_func_call = !CPP_KEYWORD_RE.match?(value) &&
                           !UE_TYPE_RE.match?(value) &&
                           !UE_PRIM_RE.match?(value) &&
                           next_i < tokens.size &&
                           ((tokens[next_i][0] == T_PUNC && tokens[next_i][1].start_with?('(')) ||
                            (tokens[next_i][0] == T_OP   && tokens[next_i][1] == '<'))

            # Use last_emitted_token (post-processed) instead of raw tokens array
            is_after_namespace = last_emitted_value == 'namespace'

            # Variable detection: last emitted token was a type or pointer/ref operator
            last_was_type_like = last_emitted_token == T_NAME_C ||
                                  last_emitted_token == T_KW_TYPE ||
                                  (last_emitted_token == T_NAME && local_types.include?(last_emitted_value)) ||
                                  (last_emitted_token == T_KW && %w[const volatile mutable static inline extern].include?(last_emitted_value))
            is_after_type = last_was_type_like ||
                            (last_emitted_token == T_OP && last_emitted_value == '*') ||
                            (last_emitted_token == T_OP && last_emitted_value == '&') ||
                            (last_emitted_token == T_OP && last_emitted_value&.end_with?('>'))

            new_token = if is_after_namespace
                          # namespace name takes priority over UE_TYPE_RE
                          T_NAME_NS
                        elsif local_types.include?(value)
                          T_NAME_C
                        elsif template_params.include?(value)
                          T_NAME_C
                        elsif UE_CORE_RE.match?(value)
                          T_NAME_D
                        elsif UE_UTIL_RE.match?(value)
                          T_NAME_B
                        elsif ue_macro_depth > 0 && punc_depth > 0 &&
                              !UE_CORE_RE.match?(value) && !UE_UTIL_RE.match?(value) &&
                              !UE_TYPE_RE.match?(value) && !UE_PRIM_RE.match?(value) &&
                              !template_params.include?(value)
                          # Inside UE macro args: followed by '=' → key (.nn green)
                          #                       otherwise      → enum value (.no amber)
                          # key=value  only when followed by ="string"
                          # meta=(...)  → enum value (amber)
                          # Category="..." → key (green)
                          eq_idx = i + 1
                          eq_idx += 1 while eq_idx < tokens.size && tokens[eq_idx][0] == T_TEXT
                          after_eq_idx = eq_idx + 1
                          after_eq_idx += 1 while after_eq_idx < tokens.size && tokens[after_eq_idx][0] == T_TEXT
                          is_key = eq_idx < tokens.size &&
                                   tokens[eq_idx][0] == T_OP && tokens[eq_idx][1] == '=' &&
                                   after_eq_idx < tokens.size &&
                                   tokens[after_eq_idx][1].start_with?('"')
                          is_key ? T_NAME_NS : T_NAME_NO
                        elsif UE_TYPE_RE.match?(value)
                          T_NAME_C
                        elsif UE_PRIM_RE.match?(value)
                          T_NAME_C
                        elsif UE_LOG_RE.match?(value)
                          T_NAME_B
                        elsif STL_OBJECTS_RE.match?(value)
                          T_NAME_VG
                        elsif STL_FUNCS_RE.match?(value)
                          T_NAME_F
                        elsif is_func_call
                          T_NAME_F
                        elsif is_member_access || is_after_type
                          T_NAME_VI
                        elsif local_vars.include?(value)
                          T_NAME_VI
                        else
                          token
                        end

            # Skip whitespace tokens when updating last_emitted
            unless token == T_TEXT
              last_emitted_token = new_token
              last_emitted_value = value
            end
            block.call(new_token, value)
          elsif token == T_KW && CONTROL_KEYWORDS.include?(value)
            block.call(T_KW_DECL, value)
          else
            unless token == T_TEXT
              last_emitted_token = token
              last_emitted_value = value
            end
            block.call(token, value)
          end

          i += 1
        end
      end
    end
  end
end
