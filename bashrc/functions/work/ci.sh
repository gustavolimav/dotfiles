function searchIntegrationTest() {
  cdm portal-search-test
  gw testIntegration
  cdm portal-search-admin-web-test
  gw testIntegration
  cdm portal-search-rest-test
  gw testIntegration
  cdm search-experiences-rest-test
  gw testIntegration
  cdm portal-search-tuning-synonyms-web-test
  gw testIntegration
}

function searchUnitTest() {
  cdm portal-search-elasticsearch7-impl
  gw test
  cdm portal-search-admin-web
  gw test
  cdm search-experiences-rest-api
  gw test
  cdm search-experiences-rest-impl
  gw test
  cdm portal-search-tuning-rankings-web
  gw test
}

function searchUnitTest2() {
    local modules=(
        "portal-search-tuning-rankings-web"
    )

    local report_file="/home/me/test_report.txt"
    > "$report_file" # Clear the report file

    for module in "${modules[@]}"; do
        cd_module "$module"
        if [ $? -ne 0 ]; then
            echo "Failed to change directory to module: $module" >> "$report_file"
            continue
        fi

        echo "Running tests in module: $module"
        test_output=$(gw test 2>&1)
        echo "$test_output"

        if echo "$test_output" | grep -q "FAILED"; then
            echo "Tests failed in module: $module" >> "$report_file"
            echo "$test_output" >> "$report_file"
        fi
    done

    echo "Test report generated: $report_file"
}