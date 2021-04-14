
function indents(a,b,stuff,cmddual1fake,cmddual2fake)
% Help text
% !!0
% of many lines
% !!0
    
% including a gap
% !!0
    
    arguments (Repeating) % !!4
        a (1,1) {mustBeNumeric}                                 % !!8
        b (:,:) double                                          % !!8
        stuff {mustBeMember(stuff, { 'this' 'that' 'other' })}  % !!8
        cmddual1fake double  % !!8
        cmddual2fake int     % !!8
    end % !!4
    
    persistent var1 % !!4
    global     var2 % !!4
    persistent var3 % !!4
    
    
    locala = a; %#ok
    localb = b; %#ok
    localstuff = stuff; %#ok
    
    if isempty(var1) var1=1; end %#ok !!4
    if isempty(var3) var3=2; end %#ok !!4
    
    ends_in_comments_and_strings(var1, var2, var3); % !!4 has end in name
    
    % !!4
    
    block_starts_in_comments_and_strings(cmddual1fake,cmddual2fake);
    array_constant_decls();
    
    % !!4
    
    continuations_and_block_comments();
    
% $$$ !!0  
% $$$ special ignore comments
    
    has_nested_fcn(); % !!4
    
    % !!4  - after ignore comments
    
end % Comment with end in it

%!!0

function B = ends_in_comments_and_strings()
% !!0
    
% >>6
    if foo
        A = 1;
    end % <<6 end in comment after end
    
    % !!4
    
    symbol_with_end_in_it;
    
    B = A(1:end); %#ok
    
    %% cell start comment !!4
    if foo %!!4
        C = "this is the end of the line";
        % !!8
    else %!!4
        
        % !!8
    end;  D = "string end string";
    % !!4
    
    E = [ D C];
    
    if bar
        
        A = E;
        
    end; B = A(1:end);
    % !!4
    
    E = B;
    
    if baz
        
        A = C;
        
    end; B = [ 1 2 ...  % is this the end?
               3 4 ];   % !!15
    
    % !!4
    
    if foo
        
        A = E;
        
    end ... the other end
    % !! 4
    
    B = [ B A ]; % !!4
    
    str = 'This is a char array with ... in it';
    foo(str); % !!4
    
    fcncall(arg1, '...', arg3); % !!4
    1; % !!4

    % Multi- end s
    % >>8
    if foo %#ok
        if bar %#ok
            if baz
                
                A = B;
                
            else
                
            end; end; end % <<8 comment end thing
    
    % !!4
    B = A;
    
end

function out = array_constant_decls()
    
    A = [ 1 2 3 ]; %!!4
    
    Blong = [ 1 2; %!!4
              3 4; %!!14
            ]; %!!12
    
    Csep = [ 
        1 2; %!!8
        3 4; %!!8
           ]; %!!11
    
    multinest = { [ 1 2               %!!4
                    3 4 ];            %!!20
                  { 5 6 7 ...         %!!18
                    8 9 10 ...        %!!20
                  };                  %!!18
                  fcncall(10, ...     %!!18
                          12, ...     %!!26
                          [ 13 14;    %!!26
                            15 16 ])  %!!28
                } ;  %!!16
    
    nest = { ... %!!4
        1        %!!8
        [ ...    %!!8
          2 3    %!!10
        ] ...    %!!8
        3        %!!8
           };    %!!11
    
    cascade_long_name = ... %!!4
        { ...               %!!8
          1                 %!!10
          2                 %!!10
        };                  %!!8
    
    % TODO
    % I don't know why the below indents this way.
    % It should either do all max indent, or all lined up with parens.
    thing.thing.long.long.longname({ 'str' %!!4
                                     'str' %!!37
                                     'str' %!!37
                                     'str' %!!37
                                   });   %!!35
    
    thing.thing.long.long.longname('str', ... %!!4
                                   'str', ... %!!35
                                   'str', ... %!!35
                                   'str' ...  %!!35
                                  );   %!!34
    
    % Line starting with end inside parens
    disp(Csep(1:  ...  %!!4
              end));   %!!14

    % This array has bad syntactic expression parsing due to the
    % apostrophy
    Closures = [ 
        755009 ; ... % 21-Feb-2067 Washington's Birthday (Mon)
        755010 ;     % !!8
               ];
    
    dep = [
        root(info.function, factory, workspace, []), ...    % likewise this isn't a keyword
        fcn3.finalize                                       % the single quote used to break [] scanning
          ];
    
    % This long fcn name last symbol starts with 'get' which
    % used to confuse and move to indent past 1st arg.
    if qesimcheck.utils.GetYesNoAnswer('Do ',... !!4
                                       'n',...  !!39
                                       'once') %!!39
        code();  %!!8
    end  %!!4
    
    
    
    % !!4
    out = { A     %!!4
            Blong %!!12
            Csep  %!!12
            nest  %!!12
            multinest%!!12
            cascade_long_name%!!12
            Closures%!!12
            dep %!!12
          };      %!!10

end

function C = block_starts_in_comments_and_strings(varargin)
% !!0
    
    C = 0;
    
    if varargin{1} % if true
        
        % !!8
    else % !!4

        % !!8
    end % if true
    
    
    % see previous function
    % !!4
    for x=1:length(C) % !!4
        if varargin{2}  % !!8
            continue    % !!12
        end   % !!8
        
        break % !!8
              % !!14
        
        %!!8
    end

    switch foo()  %!!4
      case 1  %!!6
        
        %!!8
      otherwise %!!6
        
        %!!8
    end %!!4
    
    
    try
        % !!8
    catch %!!4    
        
        % !!8
    end
    
end

function B = continuations_and_block_comments
% !!0
% !!0
% !!0
    
%{
  !!2  {  }
  !!2
%}
    
    arg1=1;
    
    %{
    %  !!4
      !!6
    % !!4
    %}
    
    % Block comment indicators MUST be on a line by themselves.
    %{ Not a block comment }
    
    foo(1); % !!4   - don't indent this special
    
    %} Not an end to a block comment {
    
    foo(arg1, ... %!!4
        arg2);  %!!8
    
    foo_long_fcn(arg1, ... %!!4
                 arg2); %!!17
    
    A = [ 1 2  % !!4
          3 4 ]; % !!10
    
    foo(['this is a very long string' ... %!!4
         'with a continution to do something very exciting']);%!!9
    
    set(gcf,'Position',[ 1 2 3 4], ... !!4
            'Color', 'red');  % !!12
    
    B = A + 1 + 4 ...
        + 6; % !!8
    
    foo_code();  % eol-comment !!4
                 % continuation-comment !!17
    
    % !!4 -blank between this & continuation comment
    % !!4 - more comments

    if condition1 || ...  % !!4
            fcn_call(arg1, ... % !!12
                     arg2)  % !!21
        line_in_if();
    end  % !!4
    
    
    
end

function has_nested_fcn

    plot(1:10); %!!4
    
    A = 1;
    
    function am_nested_fcn() %!!4
    % help
    % !!4
        code(A);
        %!!8
    end
    
    %!!4
    am_nested_fcn();
    function_end_same_line(1);
    function_after_end_same_line();
end

function b=function_end_same_line(a), b=a; end %!!0

function function_after_end_same_line()%!!0
%!!0
    disp('foo');%!!4
    
    debug_cmd_dual();
    
end%!!0

function debug_cmd_dual ()
% These dbstop command dual content have 'if' blocks in them.
% The command dual detection needs to block these from being
% detected as block initiators which would cause indentaiton.
    
    dbstop in hRandomFile at 14 if func() % !!4
    dbstop in hRandomFile at 30@1 if x==1 % !!4
    dbstop in hPFile                      % !!4
    dbstop in hSimpleFile at 2            % !!4
    dbstop if error                       % !!4
    
    %!!4

    debug_cmd_dual(); %!!4
    
end