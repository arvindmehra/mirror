class BehindCurtain
	include SuckerPunch::Job

	def perform(filter_id)
		filter = Filter.find(filter_id)
		users = filter.get_scope_users.count
		SuckerPunch.logger.info "Gettin filters for #{filter.name} total usrs #{users}"
	end
end