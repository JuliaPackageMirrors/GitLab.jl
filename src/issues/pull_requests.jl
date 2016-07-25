####################
# PullRequest Type #
####################

type PullRequest <: GitLabType
    base::Nullable{Branch}
    head::Nullable{Branch}
    number::Nullable{Int}
    id::Nullable{Int}
    comments::Nullable{Int}
    commits::Nullable{Int}
    additions::Nullable{Int}
    deletions::Nullable{Int}
    changed_files::Nullable{Int}
    state::Nullable{GitLabString}
    title::Nullable{GitLabString}
    body::Nullable{GitLabString}
    merge_commit_sha::Nullable{GitLabString}
    created_at::Nullable{Dates.DateTime}
    updated_at::Nullable{Dates.DateTime}
    closed_at::Nullable{Dates.DateTime}
    merged_at::Nullable{Dates.DateTime}
    url::Nullable{HttpCommon.URI}
    html_url::Nullable{HttpCommon.URI}
    assignee::Nullable{Owner}
    user::Nullable{Owner}
    merged_by::Nullable{Owner}
    milestone::Nullable{Dict}
    _links::Nullable{Dict}
    mergeable::Nullable{Bool}
    merged::Nullable{Bool}
    locked::Nullable{Bool}
end

PullRequest(data::Dict) = json2gitlab(PullRequest, data)
PullRequest(number::Real) = PullRequest(Dict("number" => number))

namefield(pr::PullRequest) = pr.number

###############
# API Methods #
###############

function pull_requests(repo; options...)
    results, page_data = gh_get_paged_json("/api/v3/projects/$(repo.project_id.value)/pulls"; options...)
    return map(PullRequest, results), page_data
end

function pull_request(repo, pr; options...)
    result = gh_get_json("/api/v3/projects/$(repo.project_id.value)/pulls/$(name(pr))"; options...)
    return PullRequest(result)
end
