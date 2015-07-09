name "development"
description "the development environment"
override_attributes ({
	"elasticsearch" => {
		"cluster_name" => "development-elk"
	}
})