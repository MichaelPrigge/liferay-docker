#!/bin/bash

source ../_test_common.sh
source ./scan_docker_image.sh

function main {
	set_up

	test_scan_docker_image_nightly
	test_scan_docker_image_set_liferay_docker_image_name

	tear_down
}

function set_up {
	export _BUILD_TIMESTAMP=1234567890
	export _PRODUCT_VERSION="2025.q4.1"
}

function tear_down {
	unset LIFERAY_DOCKER_IMAGE_NAME
	unset LIFERAY_RELEASE_OUTPUT
	unset _BUILD_TIMESTAMP
	unset _PRODUCT_VERSION
}

function test_scan_docker_image_nightly {
	LIFERAY_RELEASE_OUTPUT="nightly"

	_scan_docker_image &> /dev/null

	assert_equals "${?}" "${LIFERAY_COMMON_EXIT_CODE_SKIPPED}"

	unset LIFERAY_RELEASE_OUTPUT
}

function test_scan_docker_image_set_liferay_docker_image_name {
	set_liferay_docker_image_name &> /dev/null

	assert_equals \
		"${LIFERAY_DOCKER_IMAGE_NAME}" \
		"liferay/release-candidates:${_PRODUCT_VERSION}-${_BUILD_TIMESTAMP}"

	LIFERAY_RELEASE_OUTPUT="nightly"

	set_liferay_docker_image_name &> /dev/null

	assert_equals \
		"${LIFERAY_DOCKER_IMAGE_NAME}" \
		"liferay/dxp:7.4.13.nightly"
}

main "${@}"